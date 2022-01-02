import beeminder/client
import yeetout
import std/logging
import config

proc execGoalCommand*(authToken: string, goalSlug: string) =
    let goal = getGoal(authToken, goalSlug)

    debug("goal fetched", goalSlug)

    if prettyOutput:
        echo goal
    else:
        yeet("goal fetched", @[strArg("goalSlug",goalSlug)])