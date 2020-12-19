import ../utils

type Data = object
  time: int
  schedules: seq[int]

proc processData(data: string): Data =
  let lines = data.strip.splitLines
  result = Data(time: parseInt(lines[0]), schedules: newSeq[int]())

  for sched in lines[1].split(","):
    if sched == "x":
      result.schedules.add(-1)
    else:
      result.schedules.add(parseInt(sched))

proc eval1(data: Data): auto =
  var times: seq[(int, int)]
  for sched in data.schedules:
    if sched != -1:
      let wait = sched - (data.time mod sched)
      times.add (sched, wait)
  times.sort(cmp = proc(a, b: (int, int)): int = a[1] - b[1])
  times[0][0] * times[0][1] 

proc getPattern(scheds: seq[int]): seq[(int, int)] =
  var pattern: seq[(int, int)]
  for i, s in scheds:
    pattern.add (i, s)
  pattern.filterIt(it[1] != -1).mapIt((it[0] mod it[1], it[1]))


proc findCycle(a, b: (int, int)): (int, int) =
  result[1] = lcm(a[1], b[1])

  var x = 0
  while (x * a[1] + a[0]) mod b[1] != (b[1] - b[0]) mod b[1]:
    if x * a[1] > result[1]:
      raise ValueError.newException "no cycle possible"
    inc x
  result[0] = x * a[1] + a[0]


proc eval2(data: Data): auto =
  let pattern = getPattern(data.schedules)

  let total = pattern.foldl(findCycle(a, b))[0]

  total


proc main() =
  
  let data = todaysData(13).processData()
  echo "part 1: ", eval1 data
  echo "part 2: ", eval2 data



when isMainModule:
  main()

  let testData1 = """939
7,13,x,x,59,x,31,19"""

  let testData2 = """123
7,13,x,x,59,x,31,19"""

  let test3 ="""123
17,x,13,19"""

  let test4 ="""123
67,7,59,61"""



  assert testData1.processData().eval1() == 295
  assert testData2.processData().eval2() == 1068781
  assert test3.processData().eval2() == 3417
  assert test4.processData().eval2() == 754018

  let data = todaysData(13).processData()

  assert data.eval1() == 205
  assert data.eval2() == 803025030761664

  echo """1
2,x,4,3""".processData().eval2()