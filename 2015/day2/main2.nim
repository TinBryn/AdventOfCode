import os
import strutils
import sequtils
import sugar

let day = 2

let data = readFile("2015" / "days" / "day" & $day / "data" & $day).strip

func paper(dim: seq[int]): int =
  let
    l = dim[0]
    w = dim[1]
    h = dim[2]
    lw = l*w
    wh = w*h
    hl = h*l
  min(lw, min(wh, hl)) + 2 * (lw + wh + hl)

func ribbon(dim: seq[int]): int =
  let
    l = dim[0]
    w = dim[1]
    h = dim[2]
    lw = 2*(l+w)
    wh = 2*(w+h)
    hl = 2*(h+l)
  
  min(lw, min(wh, hl)) + l*w*h

proc eval(data: string, f: (seq[int]) -> int) =
  echo data.splitLines.mapIt(it.split("x").map(parseInt).f).foldl(a+b)


eval data, paper
eval data, ribbon
