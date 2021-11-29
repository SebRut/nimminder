# Package

version       = "0.1.0"
author        = "Sebastian Rutofski"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["nimminder"]

task test, "Runs the test suite":
  exec "testament all"


# Dependencies

requires "nim >= 1.4.8"
