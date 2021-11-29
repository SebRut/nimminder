import beeminder/client
import std/strutils
import std/times
import std/strformat
import std/sequtils
import std/logging

proc execGoalOverviewCommand*(authToken: string) =
    let user = getUser(authToken)
    debug("user fetched: " & $user)

    let goals = user.goals
    info(&"{goals.len} goals fetched")

    if goals.len == 0:
        echo "No goals found."
        return

    let maxSlugLength = goals.mapIt(it.len).max

    for goalSlug in goals:
        let goal = getGoal(authToken, goalSlug)
        let losedateDatetime = fromUnix(goal.losedate)
        debug("losedate parsed: " & $losedateDatetime)
        debug(&"time to derailement: {losedateDatetime - getTime()}")
        let derailment = toParts(losedateDatetime - getTime())


        var derailmentTextParts: seq[string] = @[]
        if derailment[Weeks] > 0:
            derailmentTextParts.add(&"{derailment[Weeks]} weeks(s)")
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
