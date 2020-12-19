import ../utils


template eval(data: string, op: untyped) =

  const version = 4

  when version == 0:

    echo toSeq(data.split("\n\n")).mapIt(toSeq(it.split("\n")).map(toCharSet).foldl(op).len).sum()

  elif version == 1:

    var count = 0
    for group in data.strip().split("\n\n"):
      var sets: seq[set[char]]
      for member in group.split("\n"):
        var aSet: set[char]
        for answer in member:
          aSet.incl(answer)
        sets.add(aSet)
      var anyAnswer = sets[0]
      for aSet in sets[1..^1]:
        let
          a {.inject.} = anyAnswer
          b {.inject.} = aSet
        anyAnswer = op
      count.inc(card(anyAnswer))
    
    echo count

  elif version == 2:

    let groupAnswers = iterator(): set[char] =
      for group in data.strip().split("\n\n"):

        let groupAnswers = group.split("\n").map(toCharSet)

        yield groupAnswers.foldl(op)

    echo toSeq(groupAnswers.items()).mapIt(card(it)).foldl(a + b)

  elif version == 3:

    let groups = iterator(): seq[string] =
      var group: seq[string]
      for line in data.splitLines:
        if line == "":
          yield group
          group = @[]
        else:
          group.add line

    let groupResults: seq[seq[set[char]]] = toSeq(groups.items()).mapIt(it.map(toCharSet))
    
    echo groupResults.mapIt(it.foldl(op).len).foldl(a + b)

  elif version == 4:

    let groupToAnswerCounts = proc(group: string): int {.closure.} =
      let members = group.split("\n")
      let memberAnswerSets = members.map(toCharSet)
      let combinedAnswerSet = memberAnswerSets.foldl( op )
      card(combinedAnswerSet)

    let groups = data.strip().split("\n\n")
    echo groups.map(groupToAnswerCounts).sum()

  else:
    echo "invalid version"

proc main() =
  
  let data = todaysData(6)

  eval data, a+b
  eval data, a*b

when isMainModule:
  main()

  let test = """abc

a
b
c

ab
ac

a
a
a
a

b
"""

eval test, a+b
eval test, a*b
