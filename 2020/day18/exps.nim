import strutils
import re

iterator shuntingYard(exp: string, precidence: bool): string =
  let tokenPattern = re"\+|\*|\(|\)|\d+"
  var stack: seq[string]
  for token in exp.findAll(tokenPattern):
    case token:
    of "+":
      if stack.len > 0:
        case stack[^1]:
        of "+":
          yield stack.pop()
        of "*":
          if not precidence:
            yield stack.pop()
      stack.add token
    of "*":
      if stack.len > 0:
        case stack[^1]:
        of "+", "*":
          yield stack.pop()
      stack.add token
    of "(":
      stack.add token
    of ")":
      while stack.len > 0 and stack[^1] != "(":
        yield stack.pop()
      if stack.len > 0:
        discard stack.pop()
    else:
      yield(token)
  while stack.len > 0:
    yield stack.pop()

proc parseExp*(exp: string, precidence = false): int =
  var stack: seq[int]

  for token in shuntingYard(exp, precidence):
    case token:
    of "+":
      let a = stack.pop()
      let b = stack.pop()
      stack.add a + b
    of "*":
      let a = stack.pop()
      let b = stack.pop()
      stack.add a * b
    else:
      let val = parseInt(token)
      stack.add val
  stack[0]


when isMainModule:
  let s = parseExp("1 + (2 * 3) + 4")
  echo s