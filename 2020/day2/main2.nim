import ../utils

type Policy = object
  l, h: int
  c: char

type Password = object
  p: Policy
  phrase: string

proc parseData(line: string): Password =
  ##
  let pw = line.split(":")
  result.phrase = pw[1]
  result.p.c = pw[0][^1]
  let r = pw[0][0 .. ^3].split("-")
  result.p.l = parseInt(r[0])
  result.p.h = parseInt(r[1])

proc isValid1(pw: Password): bool =
  let c = pw.phrase.count(pw.p.c)
  c in pw.p.l .. pw.p.h

proc isValid2(pw: Password): bool =
  let a = pw.phrase[pw.p.l] == pw.p.c
  let b = pw.phrase[pw.p.h] == pw.p.c

  a xor b


proc eval(data: string): string =

  let ns = data.splitLines.filterIt(it.len > 0).map(parseData)
    
  $ns.countIt(it.isvalid1) & '\n' & $ns.countIt(it.isValid2)


proc main() =
  
  let data = todaysData(2)
  
  echo eval data

when isMainModule:
  main()
