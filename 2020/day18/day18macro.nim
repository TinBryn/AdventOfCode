import macros
import ../utils

proc swapOps2(input: string): string =
  input.multiReplace(("+", "*"), ("*", "+"))

proc swapOps1(input: string): string =
  input.replace("*", "-")


proc evalExpr(exp: NimNode, part1 = true): int =
  case exp.kind:
  of nnkInfix:
    let a = evalExpr(exp[1], part1)
    let b = evalExpr(exp[2], part1)
    if $exp[0] == "+":
      if part1:
        a + b
      else:
        a * b
    elif $exp[0] == "*":
      a + b
    else:
      a * b
  of nnkIntLit:
    exp.intVal.int
  of nnkPar:
    evalExpr(exp[0], part1)

  else:
    echo exp.treeRepr
    0

static:
  let data = todaysData(18)
  var count1 = 0
  var count2 = 0
  for line in data.strip.splitLines:
    let value1 = evalExpr(line.swapOps1().parseExpr(), true)
    let value2 = evalExpr(line.swapOps2().parseExpr(), false)
    inc count1, value1
    inc count2, value2
  echo count1
  echo count2
