import ../utils

let data = todaysData(5)

func toSet(s: seq[char]): set[char] =
  for c in s:
    result.incl(c)

proc nice1(str: string): bool =

  # echo str

  let vowels = toSeq(str).filterIt(it in {'a', 'e', 'i', 'o', 'u'}).len >= 3


  let naughty = ["ab", "cd", "pq", "xy"]

  let ss = str[0..^2].zip(str[1..^1]).mapIt(it[0] & it[1])

  let hasDouble = countIt(ss, it[0] == it[1]) > 0

  let noDisallowed = ss.filterIt(it in naughty).len == 0

  hasDouble and vowels and noDisallowed

proc adjacents(str: string): seq[string] =
  @[]

proc nice2(str: string): bool =
  false


proc eval(data: string) =
  echo data.strip.splitLines.countIt(it.nice1)

eval data

echo nice1 "ugknbfddgicrmopn"
echo nice1 "jchzalrnumimnmhp"
echo nice1 "haegwjzuvuyypxyu"
echo nice1 "dvszwmarrgswjxmb"
