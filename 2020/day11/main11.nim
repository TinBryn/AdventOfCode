import ../utils

type
  Seat = enum
    floor = ".",
    empty = "L",
    occupied = "#"

  Layout = object
    seats: seq[Seat]
    width, height: int

proc `[]`*(layout: Layout, x, y: int): Seat =
  layout.seats[x + y * layout.width]


proc `[]=`*(layout: var Layout, x, y: int, val: Seat) =
  layout.seats[x + y * layout.width] = val

proc `$`*(layout: Layout): string =
  for i in 0..<layout.height:
    for j in 0..<layout.width:
      result.add($(layout[j, i]))
    result.add("\n")

proc loadSeats*(data: string): Layout =
  proc toSeat(c: char): Seat =
    parseEnum[Seat]($c)
  for line in data.strip.splitLines:
    result.seats.add line.map(toSeat)
    result.width = line.len
    result.height.inc

iterator dir*(): (int, int) =
  for i in -1..1:
    for j in -1..1:
      if i != 0 or j != 0: yield(i, j)

iterator neighbours*(x, y, w, h: int): (int, int) =
  for i, j in dir():
    if x+i < 0 or x+i >= w: continue
    if y+j < 0 or y+j >= h: continue
    yield (x+i, y+j)

iterator neighboutsLOS*(l: Layout, x, y: int): (int, int) =
  let w = l.width
  let h = l.height
  for i, j in dir():
    var dist = 1
    while true:
      let x = x + i * dist
      let y = y + j * dist
      if x<0 or x>=w: break
      if y<0 or y>=h: break
      if l[x, y] != floor:
        yield (x, y)
        break
      inc dist

proc countNeighboursLOS*(layout: Layout, x, y: int): int =
  for i, j in neighboutsLOS(layout, x, y):
    if layout[i, j] == occupied:
      inc result

proc countNeighbours*(layout: Layout, x, y: int): int =
  for i, j in neighbours(x, y, layout.width, layout.height):
    if layout[i, j] == occupied:
      inc result

proc update*(layout: Layout, buffer: var Layout, limit = 4, cn: proc (layout: Layout, x, y: int): int = countNeighbours): bool =
  for y in 0..<layout.height:
    for x in 0..<layout.width:
      let curr = layout[x, y]
      case curr:
      of floor:
        discard
      of empty:
        let count = cn(layout, x, y)
        if count == 0:
          buffer[x, y] = occupied
          result = true
        else:
          buffer[x, y] = empty
      of occupied:
        let count = cn(layout, x, y)
        if count >= limit:
          buffer[x, y] = empty
          result = true
        else:
          buffer[x, y] = occupied


proc eval1*(data: string) =
  var layout1 = loadSeats(data)
  var layout2 = layout1
  while true:
    if not layout1.update(layout2):
      break
    # echo layout2
    if not layout2.update(layout1):
      break
    # echo layout2

  echo "part 1: ", layout1.seats.count(occupied)

proc eval2*(data: string) =
  var layout1 = loadSeats(data)
  var layout2 = layout1
  while true:
    if not layout1.update(layout2, limit = 5, cn = countNeighboursLOS):
      break
    # echo layout2
    if not layout2.update(layout1, limit = 5, cn = countNeighboursLOS):
      break
    # echo layout2

  echo "part 2: ", layout1.seats.count(occupied)

proc main() =
  
  let data = todaysData(11)
  eval1 data
  eval2 data



when isMainModule:
  main()