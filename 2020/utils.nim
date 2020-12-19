{.used.}

import strutils
import sequtils
import algorithm
import regex
import os
import tables
import sets

export strutils
export sequtils
export algorithm
export regex
export os
export tables
export sets

proc todaysData*(day: int): string =
  readFile("2020" / "day" & $day / "data" & $day)

proc toCharSet*(str: string): set[char] =
  for c in str:
    result.incl c

template sum*(arr: untyped): untyped =
  arr.foldl(a + b)

template splitAt*(sequence, predicate: untyped): untyped =
  let s = sequence
  var result = newSeq[typeof(s)]()
  if s.len == 0:
    result = @[]
  elif s.len == 1:
    result = @[s]
  else:
    let iter = iterator(): typeof(s) =
      var start = s.low
      for i in s.low ..< s.high:
        let
          a {.inject.} = s[i]
          b {.inject.} = s[i+1]
        if predicate:
          yield s[start..i]
          start = i + 1
      if start == s.low:
        yield s
    result = toSeq(iter.items())
  result

func gcd*[T](a, b: T): T =
  var (a, b) = (a, b)
  while b != 0:
    (a, b) = (b, a mod b)
  a

func lcm*[T](a, b: T): T =
   a * b div gcd(a, b)