import ../utils
import unittest

type
  Masks = (set[0..35], set[0..35])
  Instruction = tuple
    a, v: int
  Section = object
    masks: Masks
    inst: seq[Instruction]
  Data = object
    sections: seq[Section]


proc `$`*(i: Instruction): string =
  "mem[" & $i.a & "] = " & $i.v

proc `$`*(s: Section): string =
  result = "mask = " & $s.masks & "\n"
  for i in s.inst:
    result.add $i
    result.add '\n'

proc getMasks(mask: string): Masks =
  for i, c in mask:
    case c:
    of '0':
      result[1].incl(35-i)
    of '1':
      result[0].incl(35-i)
    of 'X':
      discard
    else:
      echo "Bad mask char"

const fullSet = block:
  var r: set[0..35]
  for i in 0..35:
    r.incl i
  r

proc applyMasks1(val: int, masks: Masks): int =
  let s = cast[int](masks[0])
  let r = not cast[int](masks[1])
  (val or s) and r

proc floatBit(vals: seq[int], bit: int): seq[int] =
  let vals = vals
  result = vals
  for v in vals:
    result.add(v xor (1 shl bit))

proc applyMasks2(address: int, masks: Masks): seq[int] =

  let f = fullSet - masks[0] - masks[1]
  let a = cast[set[0..35]](address)

  result = @[cast[int](a + masks[0])]
  for s in f:
    result = floatBit(result, s)
  

proc applyInstruction1(
  tab: var Table[int, int],
  masks: Masks,
  inst: Instruction,
  ) =
    tab[inst.a] = applyMasks1(inst.v, masks)

proc applyInstruction2(
  tab: var Table[int, int],
  masks: Masks,
  inst: Instruction,
) =
  for a in applyMasks2(inst.a, masks):
    tab[a] = inst.v

proc execute(data: seq[Section], op = applyInstruction1): Table[int, int] =
  for section in data:
    for i in section.inst:
      result.op(section.masks, i)

proc processData(input: string): Data =
  var section: Section
  for line in input.strip.splitLines:
    if line.startsWith("mask"):
      if section.inst.len > 0:
        result.sections.add section
        section.inst = @[]
      let mask = line[7..42]
      section.masks = getMasks(mask)
    else:
      let last = line.find(']')
      let address = parseInt(line[4..<last])
      let val = parseInt(line[last+4..^1])

      section.inst.add (address, val)
  if section.inst.len > 0:
    result.sections.add section

proc eval1(data: Data): int =
  let tab = execute(data.sections)
  for k, v in tab:
    inc result, v

proc eval2(data: Data): int =
  let tab = execute(data.sections, applyInstruction2)
  for k, v in tab:
    inc result, v

proc main() =
  
  let data = todaysData(14).processData()
  # for section in data.sections:
  #   echo section
  echo "part 1: ", eval1 data
  echo "part 2: ", eval2 data


proc tests() =
  let data = """mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
""".processData()

  let data2 = """mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1""".processData()

  suite "part 1":
    test "example 1":
      check eval1(data) == 165

    test "mask 1":
      let masks = getMasks("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      check:
        applyMasks1(11, masks) == 73
        applyMasks1(101, masks) == 101
  
  suite "part 2":
    test "example 1":
      check eval2(data2) == 208


tests()

main()
