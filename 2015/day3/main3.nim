import ../utils
import sets

let data = todaysData(3)


proc move(x, y: var int, dir: char) =
  case dir:
  of '^': inc y
  of 'v': dec y
  of '>': inc x
  of '<': dec x
  else:
    discard

proc eval(data: string) =
  var
    x = 0
    y = 0
    v = initHashSet[(int, int)]()

  for c in data:
    v.incl (x, y)
    move(x, y, c)
  
  echo card(v)

  x = 0
  y = 0
  v = initHashSet[(int, int)]()
  var
    rx = 0
    ry = 0

  v.incl (0, 0)
  for i, c in data:
    if i mod 2 == 0:
      move(x, y, c)
      v.incl (x, y)
    else:
      move(rx, ry, c)
      v.incl (rx, ry)

  echo card(v)



eval data
