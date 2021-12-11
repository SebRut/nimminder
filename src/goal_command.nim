import beeminder/client
import yeetout

proc execGoalCommand*(authToken: string, goalSlug: string) =
    let goal = getGoal(authToken, goalSlug)
    yeet("goal fetched", @[strArg("goalSlug",goalSlug)])