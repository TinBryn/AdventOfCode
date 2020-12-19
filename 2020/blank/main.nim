import ../utils

type Data = object

proc processData(input: string): Data =
  Data()

proc eval1(data: Data): int = 
  return 1

proc eval2(data: Data): int =
  return 2

proc main() =
  
  let data = todaysData(0#[remember to change this value]#).processData()
  echo "part 1: ", eval1 data
  echo "part 2: ", eval2 data

import unittest

proc tests() =
  let test1 = """
""".processData()

  let test2 = """
""".processData()

  suite "part 1":
    test "data 1":
      check eval1(test1) == 1
  
  suite "part 2":
    test "data 2":
      check eval2(test2) == 2


tests()

main()
