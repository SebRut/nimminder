import beeminder/client
import std/unittest

discard """ """

check parseDatapointString("^^^ 42") == Datapoint(daystamp: "^^^", value: 42)