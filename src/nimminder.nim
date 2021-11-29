import std/parseopt
import std/strutils
import std/os
import goal_overview_command
import goal_command
import add_datapoint_command
import std/logging
import std/strformat

let logBaseDir = getEnv("XDG_STATE_HOME", getEnv("HOME") / ".local/state")
let logDir = logBaseDir / "nimminder"
let logFile = logDir / "nimminder.log"
createDir(logDir)

addHandler(newRollingFileLogger(logFile, mode = fmAppend,
        fmtStr = "[$datetime] - $levelname: "))
addHandler(newConsoleLogger(lvlWarn))

type MissingAuthTokenDefect = object of Defect

const authTokenEnv = "BEEMINDER_AUTH_TOKEN"

if not existsEnv(authTokenEnv):
    error(authTokenEnv & " is missing!")
    raise (ref MissingAuthTokenDefect)(msg: authTokenEnv & " is not defined!")

let authToken = getEnv(authTokenEnv)


var parser = initOptParser()

type
    Command = enum
        overview,
        goal,
        createDatapoint

var command: Command = Command.overview
var goalSlug: string
var datapointInfo: string

for kind, key, val in parser.getopt():
    case kind
        of cmdArgument:
            if goalSlug == "":
                command = Command.goal
                goalSlug = key
            else:
                command = Command.createDatapoint
                datapointInfo = datapointInfo.strip() & " " & key
        of cmdShortOption, cmdLongOption:
            discard
        of cmdEnd:
            assert false

debug(&"parsed {command=} with {goalSlug=} and {datapointInfo=}")

case command
    of overview:
        execGoalOverviewCommand(authToken)
    of goal:
        execGoalCommand(authToken, goalSlug)
    of createDatapoint:
        execCreateDatapointCommand(authToken, goalSlug, datapointInfo)
