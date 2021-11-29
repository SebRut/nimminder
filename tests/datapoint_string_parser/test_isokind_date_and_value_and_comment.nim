import beeminder/client
import std/unittest

discard """ """

check parseDatapointString("2021 08 19 42 \"my comment\"") == Datapoint(daystamp: "20210819", value: 42, comment: "my comment")