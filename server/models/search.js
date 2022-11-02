import { location } from "./database.js"

export async function searchBestMatch(userId, userHobbies, xA, yA, maxDistance, blocked, notInterested) {
    const isInRange = `function (xB, yB) {
        return Math.sqrt(Math.pow(${xA} - xB, 2) + Math.pow(${yA} - yB, 2)) <= ${maxDistance}
    }`

    const distance = `function (xB, yB) {
        return Math.sqrt(Math.pow(${xA} - xB, 2) + Math.pow(${yA} - yB, 2))
    }`

    const pipeline = [
        {
            $match: {
                $and: [
                    { userId: { $ne: userId } },
                    { $expr: { $not: { $in: ["$userId", blocked] } } },
                    { $expr: { $not: { $in: ["$userId", notInterested] } } },
                    {
                        $expr: {
                            $function: {
                                body: isInRange,
                                args: ["$location.posX", "$location.posY"],
                                lang: "js"
                            }
                        }
                    }
                ]
            }
        },
        {
            $lookup: {
                from: "hobbies",
                localField: "userId",
                foreignField: "userId",
                as: "tmp"
            }
        },
        {
            $replaceRoot: {
                newRoot: {
                    $mergeObjects:
                        [{ $arrayElemAt: ["$tmp", 0] }, "$$ROOT"]
                }
            }
        },
        {
            $project: {
                userId: 1,
                identity: 1,
                location: 1,
                commonHobbies: {
                    $setIntersection: [
                        "$hobbies.hobbies",
                        userHobbies
                    ]
                }
            }
        },
        {
            $project: {
                userId: 1,
                identity: 1,
                location: 1,
                commonHobbiesCount: { $size: "$commonHobbies" }
            }
        },
        {
            $sort: { commonHobbiesCount: -1 }
        },
        {
            $limit: 1
        },
        {
            $lookup: {
                from: "identity",
                localField: "userId",
                foreignField: "userId",
                as: "tmp"
            }
        },
        {
            $replaceRoot: {
                newRoot: {
                    $mergeObjects:
                        [{ $arrayElemAt: ["$tmp", 0] }, "$$ROOT"]
                }
            }
        },
        {
            $project: {
                userId: 1,
                identity: 1,
                commonHobbiesCount: 1,
                distance: {
                    $function: {
                        body: distance,
                        args: ["$location.posX", "$location.posY"],
                        lang: "js"
                    }
                }
            }
        },
        {
            $project: { _id: 0 }
        }
    ]

    const matches = await (location.aggregate(pipeline)).toArray()
    if (matches.length == 0)
        return { "noMatch": true }

    return matches[0]
}