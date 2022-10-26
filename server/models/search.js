import { hobbies, identity } from "./database.js"

export async function searchCommonHobbies(userHobbies, userId, maxMatches, xA, yA, maxDistance) {
    const isInRange = `function (xB, yB) {
        return Math.sqrt(Math.pow(${xA} - xB, 2) + Math.pow(${yA} - yB, 2)) <= ${maxDistance}
    }`

    const identityPipeline = [{
        $match: {
            $and: [
                { userId: { $ne: userId } },
                {
                    $expr: {
                        $function: {
                            body: isInRange,
                            args: ["$identity.posX", "$identity.posY"],
                            lang: "js"
                        }
                    }
                }
            ]
        }
    }]

    const identityMatches = await (identity.aggregate(identityPipeline)).toArray()

    const userIdMatches = identityMatches.map(i => i.userId);

    const hobbiesPipeline = [
        { $match: { $expr: { $in: ["$userId", userIdMatches] } } },
        {
            $project: {
                _id: 0,
                userId: 1,
                commonHobbies: {
                    $setIntersection: [
                        "$hobbies",
                        userHobbies
                    ]
                }
            }
        },
        {
            $project: {
                userId: 1,
                distance: 1,
                commonHobbiesCount: { $size: "$commonHobbies" }
            }
        },
        { $sort: { commonHobbiesCount: -1 } },
        { $limit: maxMatches }
    ]

    const hobbiesMatches = await (hobbies.aggregate(hobbiesPipeline)).toArray()

    const matches = hobbiesMatches.map(hobbyMatch => {
        const identityMatch = identityMatches.find(im => im.userId === hobbyMatch.userId)
        const distance = Math.sqrt(Math.pow(xA - identityMatch.identity.posX, 2)
            + Math.pow(yA - identityMatch.identity.posY, 2))
        const commonHobbiesCount = hobbyMatch.commonHobbiesCount
        const matchIdentity = identityMatch.identity
        return { commonHobbiesCount, matchIdentity, distance }
    })

    return matches
}