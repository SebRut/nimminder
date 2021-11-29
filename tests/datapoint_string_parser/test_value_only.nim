import beeminder/client
import std/unittest

discard """ """

check parseDatapointString("42.69") == Datapoint(value: 42.69)