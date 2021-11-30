import beeminder/client
import std/strutils
import std/times
import std/strformat
import std/sequtils
import std/logging
import std/terminal

proc getDerailmentText(losedate: Time): string =
    debug("losedate parsed: " & $losedate)
    debug(&"time to derailement: {losedate - getTime()}")
    let derailment = toParts(losedate - getTime())


    var derailmentTextParts: seq[string] = @[]
    if derailment[Weeks] > 0:
        derailmentTextParts.add(&"{derailment[Weeks]} weeks(s)")
    if derailment[Days] > 0:
        derailmentTextParts.add(&"{derailment[Days]} day(s)")
    if derailment[Hours] > 0:
        derailmentTextParts.add(&"{derailment[Hours]} hour(s)")
    if derailment[Minutes] > 0:
        derailmentTextParts.add(&"{derailment[Minutes]} minute(s)")


    alignString(derailmentTextParts.join(", "), 20)

proc getForegroundColor(losedate: Time): ForegroundColor =
    if losedate - getTime() < initDuration(days = 1):
        return fgRed
    elif losedate - getTime() < initDuration(days = 3):
        return fgYellow
    return fgDefault


proc processGoal(authToken: string, maxSlugLength: int, goalSlug: string) =
    let goal = getGoal(authToken, goalSlug)

    let losedate: Time = fromUnix(goal.losedate)

    let derailmentText = getDerailmentText(losedate)
    let fmtSlug = alignString(goalSlug, maxSlugLength)

    let line = &"{fmtSlug}\tderails in {derailmentText}\t{goal.fineprint}"

    styledEcho getForegroundColor(losedate), line.strip()

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
        processGoal(authToken, maxSlugLength, goalSlug)
