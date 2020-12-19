import ../utils
import tables
import sets


type
  Rule = object
    color: string
    contents: Table[string, int]

  Relations = object
    decendants, ancestors: Table[string, int]

  Graph = object
    tab: Table[string, Relations]


proc `$`*(graph: Graph): string =
  for bag, rel in graph.tab:
    for pred, count in rel.ancestors:
      result.add("(" & pred & ", " & $count & ")")


    if len(rel.ancestors) > 0:
      result.add " -> "

    result.add bag

    if len(rel.decendants) > 0:
      result.add " -> "

    for pred, count in rel.decendants:
      result.add("(" & pred & ", " & $count & ")")

    result.add('\n')

proc initRelations*(): Relations = Relations(decendants: initTable[string, int](), ancestors: initTable[string, int]())

proc `[]`*(graph: Graph, idx: string): Relations =
  graph.tab[idx]

proc `[]=`*(graph: var Graph, idx: string, rel: Relations) =
  graph.tab[idx] = rel

proc `[]`(graph: var Graph, idx: string): var Relations =
  graph.tab[idx]

proc contains*(graph: Graph, idx: string): bool = graph.tab.contains(idx)

proc add(graph: var Graph, bag: string) =
  if bag notin graph:
    graph[bag] = initRelations()

proc add(graph: var Graph, begin, finish: string, count: int) =
  graph.add(begin)
  graph.add(finish)

  graph[begin].decendants[finish] = count
  graph[finish].ancestors[begin] = count

proc add(graph: var Graph, rule: Rule) =
  for bag, count in rule.contents:
    graph.add(rule.color, bag, count)

proc initGraph*(rules: seq[Rule]): Graph =
  result = Graph(tab: initTable[string, Relations]())
  for rule in rules:
    result.add(rule)

type OldGraph = Table[string, Table[string, int]]

proc parseRule(r: string): Rule =
  let f = r.split("bags contain")
  result.color = f[0].strip()
  let contents = f[1].strip().split(",")

  for c in contents:
    let c = c.strip(chars = Whitespace + {'.'})
    let firstSpace = c.find(' ')
    let nStr = c[0..<firstSpace]
    try:
      let count = parseInt(nStr)
      let bag = c.find(" bag")
      result.contents[c[firstSpace+1..<bag]] = count
    except:
      discard

proc canContain(rules: OldGraph, bag: string): HashSet[string] =
  for color, contains in rules:
    if color in result:
      continue
    for k, v in contains:
      if k == bag:
        result.incl(color)

const myBag = "shiny gold"

proc containsBag(rules: OldGraph, holder, target: string): bool =
  let contents = rules[holder]
  if target in contents:
    return true
  else:
    for next, _ in contents:
      if containsBag(rules, next, target):
        return true
    return false

proc eval1(data: string) = 

  let rules = data.strip().split("\n").map(parseRule).mapIt((it.color, it.contents)).toTable

  var count = 0
  for bag, _ in rules:
    if containsBag(rules, bag, myBag):
      count.inc
  
  echo count

  var current = canContain(rules, myBag)
  var checked = initHashSet[string]()
  checked.incl(myBag)

  while card(current - checked) > 0:
    var next = initHashSet[string]()
    for p in current:
      next = next + rules.canContain(p)
      checked.incl(p)
    current = current + next
  
  echo current.card()

proc countContents(bag: string, rules: OldGraph): int =
  for nextBag, count in rules[bag]:
    result.inc count * (countContents(nextBag, rules)+1)

proc eval2(data: string) =

  let rules = data.strip().split("\n").map(parseRule).mapIt((it.color, it.contents)).toTable

  echo countContents(myBag, rules)

proc main() =
  
  let data = todaysData(7)
  eval1 data
  eval2 data



when isMainModule:
  main()

  let testData1 = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.

"""

  eval1 testData1

  let testData2 = """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
"""

  eval2 testData2


  let rules = testData1.strip.splitLines.map(parseRule)

  let graph = initGraph(rules)

  echo graph
