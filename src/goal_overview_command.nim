import beeminder/client
import std/strutils
import std/times
import std/strformat
import std/sequtils

proc execGoalOverviewCommand*(authToken: string) =
    let user = getUser(authToken)
    let goals = user.goals

    if goals.len == 0:
        echo "No goals found."
        return

    let maxSlugLength = goals.mapIt(it.len).max

    for goalSlug in goals:
        let goal = getGoal(authToken, goalSlug)
        let derailment = toParts(fromUnix(goal.losedate) - getTime())

        var derailmentTextParts: seq[string] = @[]
        if derailment[Days] > 0:
            derailmentTextParts.add(&"{derailment[Days]} day(s)")
        if derailment[Hours] > 0:
            derailmentTextParts.add(&"{derailment[Hours]} hour(s)")
        if derailment[Minutes] > 0:
            derailmentTextParts.add(&"{derailment[Minutes]} minute(s)")

        let fmtSlug = alignString(goalSlug, maxSlugLength)
        let derailmentText = alignString(derailmentTextParts.join(", "), 20)
        let line = &"{fmtSlug}\tderails in {derailmentText}\t{goal.fineprint}"
        echo line.strip()
