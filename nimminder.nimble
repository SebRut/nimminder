# Package

version       = "0.3.0"
author        = "Sebastian Rutofski"
description   = "A cli for beeminder"
license       = "MIT"
srcDir        = "src"
bin           = @["nimminder"]

task test, "Runs the test suite":
  exec "testament all"


# Dependencies

requires "nim >= 1.4.8"
requires "https://github.com/SebRut/yeetout.git"