import ../utils
import intsets


proc eval1*(data: string): auto = 
  
  let ns = data.strip.splitLines.map(parseInt).sorted

  var
    ones = 1
    twos = 1
    threes = 1

  for i in 0..ns.len-2:
    case ns[i+1] - ns[i]:
    of 1:
      inc ones
    of 2:
      inc twos
    of 3:
      inc threes
    else:
      discard
  
  echo ones, ", ", threes

  ones * threes

proc tribonacci(n: int): int =
  proc trib(n: int): int =
    case n:
    of 0: 0
    of 1, 2: 1
    else:
      trib(n-1) + trib(n-2) + trib(n-3)
  trib(n)

proc paths*(data: seq[int]): int =
  let laps = splitAt(data, b - a == 3)
  laps.mapIt(tribonacci(it.len)).foldl(a * b) * 2




proc eval2*(data: string): auto =
  let ns = ("0\n" & data).strip.splitLines.map(parseInt).sorted(order = Descending)

  let iset = block:
    var res = initIntSet()
    for n in ns:
      res.incl n
    res

  var ans = newSeqWith[int](ns[0]+3, -1)
  ans[ns[0]] = 1

  proc getAnswer(jolts: int): int =

    if ans[jolts] != -1:
      ans[jolts]
    else:
      var count = 0
      for i in jolts+1..jolts+3:
        if i in iset:
          inc count, getAnswer(i)

      ans[jolts] = count

      count

  
  getAnswer(0)

proc main*() =
  
  let data = todaysData(10)
  echo "part1: ", eval1 data
  echo "part2: ", eval2 data





when isMainModule:
  main()
  let data = ("0\n" & todaysData(10)).strip().splitLines.map(parseInt).sorted

  echo paths(data)