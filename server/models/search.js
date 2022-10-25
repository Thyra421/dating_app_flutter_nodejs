import { hobbies } from "./database.js"

export async function searchCommonHobbies(userHobbies, userId, max) {
    const pipeline = [
        { $match: { userId: { $ne: userId } } },
        {
            $project: {
                userId: 1,
                hobbies: 1,
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
                hobbies: 1,
                commonHobbies: 1,
                commonHobbiesCount: { $size: "$commonHobbies" }
            }
        },
        { $sort: { commonHobbiesCount: -1 } },
        { $limit: max }
    ]
    return await (hobbies.aggregate(pipeline)).toArray()
}