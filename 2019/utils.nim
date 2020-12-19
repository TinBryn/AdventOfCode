{.used.}

import strutils
import sequtils

export strutils
export sequtils

type Array2D*[T] = object
  data*: seq[T]
  width*: int

proc initArray2D*[T](width, height: int): Array2D[T] =
  Array2D[T](data: newSeq[T](width * height), width: width)

proc `[]`*[T](arr: Array2D[T], x, y: int): T =
  arr.data[x + arr.width * y]

proc `[]`*[T](arr: var Array2D[T], x, y: int): var T =
  arr.data[x + arr.width * y]

proc `[]`*[T](arr: var Array2D[T], x, y: int, val: T) =
  arr.data[x + arr.width * y] = val