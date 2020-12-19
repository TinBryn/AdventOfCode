import os
import strutils

let data = readFile("2015" / "days" / "day1" / "data1").strip

var f = 0
var s = false

for i, c in data:
  case c:
  of '(': inc f
  of ')': dec f
  else: echo "bad char"
  if not s and f < 0:
    echo i+1
    s = true

echo f
