import beeminder/client
import std/logging

proc execGoalCommand*(authToken: string, goalSlug: string) =
    let goal = getGoal(authToken, goalSlug)
    debug("goal fetched:" & $goal)
    echo goal