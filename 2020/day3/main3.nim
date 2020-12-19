import ../utils

type Map = object
  data: seq[char]
  width, height: int

proc initMap(rows: seq[string]): Map =
  result.width = rows[0].len
  result.height = rows.len
  for r in rows:
    result.data.add(r)

proc `[]`(m: Map, x, y: int): char =
  m.data[(x mod m.width) + y * m.width]

iterator slope(m: Map, h, v: int): char =
  for y in countup(0, m.height-1, v):
    let x = y div v * h
    yield m[x, y]

proc slopeTrees(m: Map, h, v: int): int =
  countIt(m.slope(h, v), it == '#')


proc eval(data: string): string =

  let map = data.strip.splitLines.initMap

  let slopes = [
    (1, 1),
    (3, 1),
    (5, 1),
    (7, 1),
    (1, 2)
    ]

  let cs = slopes.mapIt(slopeTrees(map, it[0], it[1]))

  echo cs

  result = $cs.foldl(a * b, 1)


proc main() =
  
  let data = todaysData(3)
  
  echo eval data

when isMainModule:
  main()
