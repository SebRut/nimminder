import beeminder/client

proc execGoalCommand*(authToken: string, goalSlug: string) =
    echo getGoal(authToken, goalSlug)
