import ../utils

type OpKind = enum
  opNop = "nop"
  opJmp = "jmp"
  opAcc = "acc"

type Opcode = object
  code: OpKind
  val: int

type Vm = object
  pc: int
  acc: int
  

proc initVm(): Vm =
  Vm(pc: 0, acc: 0)

proc flipOp(op: Opcode): Opcode =
  case op.code:
  of opNop:
    Opcode(code: opJmp, val: op.val)
  of opJmp:
    Opcode(code: opNop, val: op.val)
  else:
    op

proc execute(vm: var Vm, ops: seq[Opcode], flipVal = -1): bool =
  if vm.pc == ops.len:
    return false
  let op =
    if vm.pc == flipVal:
      flipOp ops[vm.pc]
    else:
      ops[vm.pc]

  case op.code:
  of opNop:
    inc vm.pc
  of opAcc:
    inc vm.acc, op.val
    inc vm.pc
  of opJmp:
    inc vm.pc, op.val

  return true

proc `$`*(op: Opcode): string =
  if op.val > 0:
    $op.code & " +" & $op.val
  else:
    $op.code & " " & $op.val

proc parseOpcode(str: string): Opcode =
  result.code = parseEnum[OpKind](str[0..2])
  result.val = parseInt(str[4..^1])

proc executedInLoop(ops: seq[Opcode], flipVal = -1): seq[int] =
  var vm = initVm()

  var executed: seq[int]


  while true:
    if vm.pc in executed:
      return executed
    else:
      executed.add(vm.pc)
      if not vm.execute(ops, flipVal):
        return @[-1, vm.acc]


proc eval1(data: string) = 
  let ops = data.strip().splitLines().map(parseOpcode)
  var vm = initVm()

  var executed: seq[int]


  while true:
    if vm.pc in executed:
      echo vm.acc
      break
    else:
      executed.add(vm.pc)
      if not vm.execute(ops):
        break




proc eval2(data: string) =
  let ops = data.strip().splitLines().map(parseOpcode)

  for i in 0..<ops.len:
    let loop = executedInLoop(ops, i)
    # echo loop.len
    if loop[0] == -1:
      echo "op = ", align($(i+1), 3), ": ", ops[i]
      echo "acc = ", loop[1]


proc main() =
  
  let data = todaysData(8)
  eval1 data
  eval2 data



when isMainModule:
  main()

  let testData = """nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

  let testData2 = """nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

  eval1 testData
  eval2 testData2
