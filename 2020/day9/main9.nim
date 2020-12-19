import ../utils


proc isPairSumInList*(list: seq[int], span: int, offset: int): (int, int) =
  let val = list[span + offset]
  for i in offset..<offset+span:
    for j in i+1..<offset+span:
      if list[i] + list[j] == val:
        return (list[i], list[j])
  return (-1, -1)

proc eval1(data: string, span: int = 25): int {.discardable.} = 
  let ns = data.strip.splitLines.map(parseInt)

  for i in 0 ..< ns.len - span:
    let (a, b) = isPairSumInList(ns, span, i)
    if a + b != ns[i + span]:
      echo ns[i + span]
      return ns[i + span]


proc eval2(data: string, span = 25) =
  let key = eval1(data, span)

  let ns = data.strip.splitLines.map(parseInt)

  var
    i = 0
    j = 1
    sum = ns[0] + ns[1]

  while true:
    if sum < key:
      inc j
      inc sum, ns[j]
    elif sum > key:
      dec sum, ns[i]
      inc i
    else:
      let s = ns[i..j].sorted
      echo s[0], ", ", s[^1]
      echo "part2: ", s[0] + s[^1]
      break

proc main() =
  
  let data = todaysData(9)
  eval2 data



when isMainModule:
  main()

  let testData1 = """35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

  eval2 testData1, 5
