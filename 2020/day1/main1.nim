import ../utils


proc eval(data: string): string =

  let numbs: seq[int] = data.splitLines.filterIt(it.len > 0).map(parseInt).sorted

  var
    i = 0
    j = numbs.len-1

  while i < j:
    let t = numbs[i] + numbs[j]
    if t == 2020:
      result = "part 1: " & $(numbs[i] * numbs[j]) & '\n'
      break
    if t < 2020:
      inc i
    else:
      dec j


  for i, a in numbs:
    for j, b in numbs[i .. ^1]:
      if a + b > 2020:
        continue
      for c in numbs[i + j .. ^1]:
        if a + b + c == 2020:
          result &= "part 2: " & $(a * b * c) & '\n'
      



proc main() =
  
  let data = todaysData(1)

  echo eval data

when isMainModule:
  main()
