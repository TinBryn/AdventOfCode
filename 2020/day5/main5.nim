import ../utils



proc seatId(pass: string): int =
  for c in pass:
    result = result shl 1
    if c == 'B' or c == 'R':
      inc result
    
proc toRowCol(pass: string): (int, int) =
  let id = seatId(pass)

  (id shr 3, id and 7)

proc eval(data: string) =
  let passes = data.strip.splitLines
  let ids = passes.map(seatId).sorted
  let highest = ids[^1]

  echo highest

  var last = ids[0]
  for id in ids[1..^1]:
    if id - last != 1:
      echo id-1
      break
    else:
      last = id


proc main() =
  
  let data = todaysData(5)
  eval data

when isMainModule:
  main()

  let testData = """BFFFBBFRRR"""

  echo toRowCol(testData)
