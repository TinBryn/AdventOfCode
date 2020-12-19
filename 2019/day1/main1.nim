import ../utils

proc fuelForMass(mass: int): int =
  mass div 3 - 2

proc fuelForFuel(mass: int): int =
  var mass = mass
  while mass > 0:
    mass = fuelForMass(mass)
    result.inc mass

proc main() =
  let data = readfile("2019/day1/data1")

  proc fuelReq(c: proc (mass: int): int): int =
    data.splitLines
      .filterIt(it.len>0)
      .map(parseInt)
      .map(c)
      .foldl(a+b)

  echo fuelReq(fuelForMass)
  echo fuelReq(fuelForFuel)

when isMainModule:
  main()
