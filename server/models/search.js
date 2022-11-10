import { location } from "./database.js"

export async function searchBestMatch(userId, userHobbies, xA, yA, maxDistance, blocked, notInterested) {
    const isInRange = `function (xB, yB) {
        return Math.sqrt(Math.pow(${xA} - xB, 2) + Math.pow(${yA} - yB, 2)) <= ${maxDistance}
    }`

    const distance = `function (xB, yB) {
        return Math.sqrt(Math.pow(${xA} - xB, 2) + Math.pow(${yA} - yB, 2))
    }`

    const pipeline = [
        // Merge with settings
        {
            $lookup: {
                from: "settings",
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
        // Filter out blocked users, already seen users, invisible users and users not in range
        {
            $match: {
                $and: [
                    { userId: { $ne: userId } },
                    { $expr: { $not: { $in: ["$userId", blocked] } } },
                    { $expr: { $not: { $in: ["$userId", notInterested] } } },
                    { $expr: { $eq: ["$settings.appearOnSearch", true] } },
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
        // Merge with hobbies
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
        // Find common hobbies count
        {
            $project: {
                userId: 1,
                identity: 1,
                location: 1,
                commonHobbiesCount: {
                    $size: {
                        $setIntersection: [
                            "$hobbies.hobbies",
                            userHobbies
                        ]
                    }
                }
            }
        },
        // Sort by highest hobbies count
        {
            $sort: { commonHobbiesCount: -1 }
        },
        // Select the first one
        {
            $limit: 1
        },
        // Merge with identity
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
        // Add distance
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
        // Remove id
        {
            $project: { _id: 0 }
        }
    ]

    const matches = await (location.aggregate(pipeline)).toArray()
    if (matches.length == 0)
        return { "noMatch": true }

    return matches[0]
}