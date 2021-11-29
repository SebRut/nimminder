import beeminder/client
import std/unittest

discard """ """

check parseDatapointString("^ 42 my comment") == Datapoint(daystamp: "^", value: 42, comment: "my comment")