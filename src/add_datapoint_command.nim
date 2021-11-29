import beeminder/client
import std/logging

proc execCreateDatapointCommand*(authToken: string, goalSlug: string,
        datapointInfo: string) =
    let datapoint = parseDatapointString(datapointInfo)
    debug("datapoint string parsed: " & $datapoint)
    echo createDatapoint(authToken, goalSlug, datapoint)
