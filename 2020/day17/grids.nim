type
  Grid*[N: static int] = object
    shape: array[N, Slice[int]]
    data: seq[bool]

proc width*[N: static int](grid: Grid[N], dim: int): int =
  grid.shape[dim].len

template directAccess[N](grid: Grid[N], point: array[N, int]): untyped =
  let lower = block:
    var result: array[N, int]
    for i in 0..<N:
      result[i] = point[i] - grid.shape[i].a
    result
  
  let widths = block:
    var result: array[N-1, int]
    for i in 0..<N-1:
      result[i] = grid.width(i)
    result
  
  var a = lower[N-1]

  for i in countdown(N-2, 0):
    a *= widths[i]
    a += lower[i]
  
  grid.data[a]

proc `[]`*[N: static int](grid: Grid[N], point: array[N, int]): bool =
  for i in 0..<N:
    if point[i] notin grid.shape[i]:
      return false
  directAccess(grid, point)

proc `[]=`*[N: static int](grid: var Grid[N], point: array[N, int], val: bool) =
  directAccess(grid, point) = val

iterator neighbours*[N: static int](grid: Grid[N], point: array[N, int]): bool =
  yield false

type
  Grid3D* = object
    xRange*, yRange*, zRange*: Slice[int]
    data*: seq[bool]

proc width*(grid: Grid3D): int =
  grid.xRange.len

proc height*(grid: Grid3D): int =
  grid.yRange.len

proc depth*(grid: Grid3D): int =
  grid.zRange.len


template directAccess(grid: Grid3D, x, y, z: int): untyped =
  let x1 = x - grid.xRange.a
  let y1 = y - grid.yRange.a
  let z1 = z - grid.zRange.a
  let w = grid.width
  let h = grid.height

  grid.data[x1 + w*(y1 + h*z1)]


proc `[]`*(grid: Grid3D, x, y, z: int): bool =
  if x notin grid.xRange:
    return false
  if y notin grid.yRange:
    return false
  if z notin grid.zRange:
    return false

  grid.directAccess(x, y, z)

proc `$`*(grid: Grid3D): string =
  for z in grid.zRange:
    result.add "z=" & $z & "\n"
    for y in grid.yRange:
      for x in grid.xRange:
        result.add if grid[x, y, z]: "#" else: "."
      result.add "\n"
    result.add "\n"

proc `[]=`*(grid: var Grid3D, x, y, z: int, val: bool) =
  grid.directAccess(x, y, z) = val

iterator neighbours*(x, y, z: int): (int, int, int) =
  for i in x-1..x+1:
    for j in y-1..y+1:
      for k in z-1..z+1:
        if i!=x or j!=y or k!=z:
          yield (i, j, k)


iterator coords*(grid: Grid3D): (int, int, int) =
  for x in grid.xRange:
    for y in grid.yRange:
      for z in grid.zRange:
        yield (x, y, z)

proc update*(grid: var Grid3D) =
  var next = Grid3D(
    xRange: grid.xRange,
    yRange: grid.yRange,
    zRange: grid.zRange,
    data: newSeq[bool](grid.width * grid.height * grid.depth)
  )

  for x, y, z in grid.coords:
    var count = 0
    for x1, y1, z1 in neighbours(x, y, z):
      if grid[x1, y1, z1]:
        inc count
    if grid[x, y, z]:
      next[x, y, z] = count == 2 or count == 3
    else:
      next[x, y, z] = count == 3
  
  grid = next

type
  Grid4D* = object
    xRange*, yRange*, zRange*, wRange*: Slice[int]
    data*: seq[bool]


proc width*(grid: Grid4D): int =
  grid.xRange.len

proc height*(grid: Grid4D): int =
  grid.yRange.len

proc depth*(grid: Grid4D): int =
  grid.zRange.len

proc hyper*(grid: Grid4D): int =
  grid.wRange.len

template directAccess(grid: Grid4D, x, y, z, w: int): untyped =
  let x1 = x - grid.xRange.a
  let y1 = y - grid.yRange.a
  let z1 = z - grid.zRange.a
  let w1 = w - grid.wRange.a
  let width = grid.width
  let h = grid.height
  let d = grid.depth

  grid.data[x1 + width*(y1 + h*(z1 + d*w1))]

proc `[]`*(grid: Grid4D, x, y, z, w: int): bool =
  if x notin grid.xRange:
    return false
  if y notin grid.yRange:
    return false
  if z notin grid.zRange:
    return false
  if w notin grid.wRange:
    return false

  grid.directAccess(x, y, z, w)

proc `[]=`*(grid: var Grid4D, x, y, z, w: int, val: bool) =
  grid.directAccess(x, y, z, w) = val

iterator neighbours*(x, y, z, w: int): (int, int, int, int) =
  for i in x-1..x+1:
    for j in y-1..y+1:
      for k in z-1..z+1:
        for l in w-1..w+1:
          if i!=x or j!=y or k!=z or l!=w:
            yield (i, j, k, l)


iterator coords*(grid: Grid4D): (int, int, int, int) =
  for x in grid.xRange:
    for y in grid.yRange:
      for z in grid.zRange:
        for w in grid.wRange:
          yield (x, y, z, w)

proc update*(grid: var Grid4D) =
  var next = Grid4D(
    xRange: grid.xRange,
    yRange: grid.yRange,
    zRange: grid.zRange,
    wRange: grid.wRange,
    data: newSeq[bool](grid.width * grid.height * grid.depth * grid.hyper)
  )

  for x, y, z, w in grid.coords:
    var count = 0
    for x1, y1, z1, w1 in neighbours(x, y, z, w):
      if grid[x1, y1, z1, w1]:
        inc count
    if grid[x, y, z, w]:
      next[x, y, z, w] = count == 2 or count == 3
    else:
      next[x, y, z, w] = count == 3
  
  grid = next