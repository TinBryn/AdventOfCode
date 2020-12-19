import ../utils

type Data = seq[int]


iterator numbers(starting: seq[int], until: int): int =
  var found = initTable[int, int]()
  for i, s in starting[0..^2]:
    found[s] = i
  var next: int = starting[^1]
  var pos: int = starting.len
  while pos < until:
    let prev = found.getOrDefault(next, -1)
    found[next] = pos - 1
    if prev == -1:
      next = 0
    else:
      next = pos - prev - 1
    yield next
    inc pos

  


proc processData(input: string): Data =
  input.strip().split(",").map(parseInt)

proc eval(data: Data, upto: int): auto = 
  for n in numbers(data, upto):
    result = n


proc eval1(data: Data): auto = 
  eval(data, 2020)
  

proc eval2(data: Data): auto =
  eval(data, 30000000)

proc main() =
  
  let data = todaysData(15).processData()
  echo "part 1: ", eval1 data
  echo "part 2: ", eval2 data

import unittest

proc tests() =
  let test1 = """1,3,2""".processData()

  let test2 = """2,1,3""".processData()

  let test3 = """1,2,3""".processData()

  suite "part 1":
    test "data 1":
      check eval1(test1) == 1
    test "data 2":
      check eval1(test2) == 10
    test "data 3":
      check eval1(test3) == 27

    test "example":
      let t = "0,3,6".processData()
      echo 0
      echo 3
      echo 6

      for n in numbers(t, 10):
        echo n


tests()

main()
