import ../utils
import exps

type Data = seq[int]

proc processData(input: string, precidence = false): Data =
  input.strip.splitLines.mapIt(parseExp(it, precidence))

proc eval1(data: Data): int = 
  data.foldl(a+b, 0)

proc eval2(data: Data): int =
  data.foldl(a+b, 0)

proc main() =
  
  let data1 = todaysData(18).processData()
  let data2 = todaysData(18).processData(true)
  echo "part 1: ", eval1 data1
  echo "part 2: ", eval2 data2

import unittest

proc tests() =
  let test1 = """2 * 3 + (4 * 5)""".processData()

  let test2 = """5 + (8 * 3 + 9 + 3 * 4 * 3)""".processData()

  suite "part 1":
    test "data 1":
      check eval1(test1) == 26
    test "data 2":
      check eval1(test2) == 437

  
  suite "part 2":
    test "data 3":
      check eval2("2 * 3 + (4 * 5)".processData(true)) == 46
    
    test "data 4":
      check eval2(
        "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
        .processData(true)) == 669060


tests()

main()
