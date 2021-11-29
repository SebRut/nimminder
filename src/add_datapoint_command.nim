import beeminder/client

proc execCreateDatapointCommand*(authToken: string, goalSlug: string,
        datapointInfo: string) =
    let datapoint = parseDatapointString(datapointInfo)
    echo createDatapoint(authToken, goalSlug, datapoint)
