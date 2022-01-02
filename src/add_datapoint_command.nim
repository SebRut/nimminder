import beeminder/client
import std/logging
import config
import std/strformat
import yeetout

proc execCreateDatapointCommand*(authToken: string, goalSlug: string,
        datapointInfo: string) =
    let datapoint = parseDatapointString(datapointInfo)
    debug("datapoint string parsed: " & $datapoint)
    let answer = createDatapoint(authToken, goalSlug, datapoint)
    debug("datapoint created", answer)

    if prettyOutput:
        echo &"datapoint created: id={answer.id}"
    else:
        yeet("datapoint created", [strArg("id", answer.id)])
