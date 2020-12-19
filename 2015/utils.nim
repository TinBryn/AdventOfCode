{.used.}

import strutils
import sequtils
import algorithm
import regex
import os

export strutils
export sequtils
export algorithm
export regex
export os

proc todaysData*(day: int): string =
  readFile("2015" / "day" & $day / "data" & $day)
