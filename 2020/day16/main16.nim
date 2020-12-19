import ../utils

type
  Rule = object
    tag: string
    valid: set[0..999]

  Ticket = seq[int]

  Data = object
    rules: seq[Rule]
    myTicket: Ticket
    nearbyTickets: seq[Ticket]

proc parseTicket(line: string): Ticket =
  line.split(",").map(parseInt)

proc parseRule(line: string): Rule =
  let nv = line.split(": ")

  result.tag = nv[0]
  for r in nv[1].split(" or "):
    let lh = r.split("-").map(parseInt)
    result.valid = result.valid + {range[0..999](lh[0]) .. lh[1]}


proc processData(input: string): Data =
  let lines = input.strip.splitLines()
  var i = 0
  while i < lines.len:
    let line = lines[i]

    if line == "your ticket:":
      result.myTicket = lines[i+1].parseTicket()
      inc i
    elif line == "nearby tickets:":
      for j in i+1 ..< lines.len:
        result.nearbyTickets.add parseTicket(lines[j])
      break
    elif line == "":
      discard
    else:
      result.rules.add(parseRule(line))
    
    inc i

proc invalidTicketValues(ticket: Ticket, rules: seq[Rule]): seq[int] =
  for value in ticket:
    if not rules.mapIt(it.valid).anyIt(value in it):
      result.add value

proc valid(ticket: Ticket, rules: seq[Rule]): bool =
  invalidTicketValues(ticket, rules).len == 0


proc eval1(data: Data): int = 
  for ticket in data.nearbyTickets:
    result += invalidTicketValues(ticket, data.rules).foldl(a+b, 0)

proc findFieldLocations(tickets: seq[Ticket], rule: Rule): set[0..30] =
  for i in 0..<tickets[0].len:
    if tickets.allIt(it[i] in rule.valid):
      result.incl i

proc getLastValue(s: set[0..30]): int =
  for v in s:
    result = v

proc eval2(data: Data): int =
  let validTickets = data.nearbyTickets.filterIt(it.valid(data.rules))

  echo validTickets.len

  var potentials: seq[set[0..30]]

  for rule in data.rules:
    let locs = findFieldLocations(validTickets, rule)
    potentials.add locs

  var mappings: seq[(string, set[0..30])]

  for i, p in potentials:
    mappings.add (data.rules[i].tag, p)

  mappings = mappings.sortedByIt(it[1].len)

  for i in 0 ..< mappings.len:
    for j in i+1 ..< mappings.len:
      mappings[j][1] = mappings[j][1] - mappings[i][1]

  proc comp(a, b: (string, int)): int =
    cmp(a[0], b[0])

  let assoc = mappings.mapIt((it[0], it[1].getLastValue)).sorted(comp)
  result = 1
  for (t, idx) in assoc:
    if t.startsWith "departure":
      result *= data.myTicket[idx]

  # for m in assoc:
  #   echo m

proc main() =
  
  let data = todaysData(16).processData()
  echo "part 1: ", eval1 data
  echo "part 2: ", eval2 data

import unittest

proc tests() =
  let test1 = """class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
""".processData()

  let test2 = """
""".processData()

  suite "part 1":
    test "data 1":
      check eval1(test1) == 71
  
  suite "part 2":
    test "data 2":
      check eval2(test2) == 1


tests()

main()
