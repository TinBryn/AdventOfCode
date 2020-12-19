import ../utils

type
  Pos = object
    x, y: int
  ShipPos = object
    ship: Pos
    waypoint: Pos

  Motion = object
    action: char
    amount: int

proc parseLine(line: string): Motion =
  Motion(action: line[0], amount: parseInt(line[1..^1]))

proc process(data: string): seq[Motion] =
  data.strip.splitLines.map(parseLine)

proc manhattan(pos: ShipPos): int =
  abs(pos.ship.x) + abs(pos.ship.y)

proc rotate(pos: var ShipPos, amount: int) =
  let d = case amount:
  of 0: (1, 0)
  of 90: (0, 1)
  of 180: (-1, 0)
  of 270: (0, -1)
  else:
    echo "invalid angle: ", amount
    (0, 0)
  let wx = d[0] * pos.waypoint.x - d[1] * pos.waypoint.y
  let wy = d[1] * pos.waypoint.x + d[0] * pos.waypoint.y
  pos.waypoint.x = wx
  pos.waypoint.y = wy

proc forward(pos: var ShipPos, amount: int) =
  inc pos.ship.x, pos.waypoint.x * amount
  inc pos.ship.y, pos.waypoint.y * amount

proc movePos(pos: var Pos, dir: char, amount: int) =
  case dir:
  of 'N': inc pos.y, amount
  of 'E': inc pos.x, amount
  of 'S': dec pos.y, amount
  of 'W': dec pos.x, amount
  else:
    echo "invalid direction"

proc move(ship: var ShipPos, motion: Motion, pos: var Pos) =
  case motion.action:
  of 'F': ship.forward(motion.amount)

  of 'R': ship.rotate(360-motion.amount)
  of 'L': ship.rotate(motion.amount)

  of 'N','E','S','W':
    pos.movePos(motion.action, motion.amount)

  else:
    echo "invalid action"

proc eval1(data: seq[Motion]): auto = 
  var pos = ShipPos(ship: Pos(x:0, y:0), waypoint: Pos(x:1, y:0))
  for action in data:
    pos.move(action, pos.ship)
  pos


proc eval2(data: seq[Motion]): auto =
  var pos = ShipPos(ship: Pos(x:0, y:0), waypoint: Pos(x:10, y:1))
  for action in data:
    pos.move(action, pos.waypoint)
  pos



proc main() =
  
  let data = todaysData(12).process
  let part1 = eval1 data
  echo "part1: ", part1.manhattan
  let part2 = eval2 data
  echo "part2: ", part2.manhattan



when isMainModule:
  main()

  let testData1 = process "F10\nN3\nF7\nR90\nF11"


  echo eval1(testData1).manhattan
  echo eval2(testData1).manhattan
