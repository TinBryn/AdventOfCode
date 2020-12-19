import ../utils

import grids

type Data1 = Grid3D
type Data2 = Grid4D

proc processData(input: string): Data1 =
  var initial: seq[bool]
  var width: int = 1

  for line in input.strip.splitLines:
    initial.add(line.mapIt(it == '#'))
    if line.len > 0:
      width = line.len
  
  let height = initial.len div width

  echo width, " ", height

  result = Data1(
    xRange: -7..<width+7,
    yRange: -7..<height+7,
    zRange: -7..<7
  )

  result.data = newSeq[bool]((width+15) * (height+15) * 15)
  for i, j in initial:
    result[i mod width, i div width, 0] = j

proc processData2(input: string): Data2 =
  var initial: seq[bool]
  var width: int = 1

  for line in input.strip.splitLines:
    initial.add(line.mapIt(it == '#'))
    if line.len > 0:
      width = line.len
  
  let height = initial.len div width

  echo width, " ", height

  result = Data2(
    xRange: -7..<width+7,
    yRange: -7..<height+7,
    zRange: -7..<7,
    wRange: -7..<7
  )

  result.data = newSeq[bool]((width+15) * (height+15) * 15 * 15)
  for i, j in initial:
    result[i mod width, i div width, 0, 0] = j



proc eval1(data: Data1): int =
  var data = data

  for _ in 1..6:
    data.update()

  for x, y, z in data.coords:
    if data[x, y, z]:
      inc result
  

proc eval2(data: Data2): int =

  var data = data

  for _ in 1..6:
    data.update()

  for x, y, z, w in data.coords:
    if data[x, y, z, w]:
      inc result



proc main() =
  
  let data1 = todaysData(17).processData()
  let data2 = todaysData(17).processData2()
  echo "part 1: ", eval1 data1
  echo "part 2: ", eval2 data2

import unittest

proc tests() =
  let test1 = """.#.
..#
###""".processData()

  let test2 = """.#.
..#
###""".processData2()


  suite "part 1":
    test "data 1":
      check eval1(test1) == 112

  suite "part 2":
    test "data 2":
      check eval2(test2) == 848


tests()

main()
