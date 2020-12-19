import ../utils
import tables

type Fields = enum
  byr, iyr, eyr, hgt, hcl, ecl, pid, cid

iterator pp(data: string): seq[string] =
  var r: seq[string] = @[]
  for line in data.splitLInes:
    if line == "":
      yield r
      r = @[]
    else:
      r.add(line.split(" "))
  yield r

proc reqFields(k: seq[string], verbose = false): bool =
  if verbose:
    echo k
  let req = {byr, iyr, eyr, hgt, hcl, ecl, pid}

  let k = block:
    var r: set[Fields]
    for f in k.mapIt(parseEnum[Fields](it[0..2])): r.incl f
    r

  req <= k

proc hgtValid(v: string, verbose = false): bool =
  ##
  let cm = v.find("cm")
  if cm == v.len - 2:
    if verbose:
      echo v[0..^3]
    return parseInt(v[0..^3]) in 150 .. 193
  let inch = v.find "in"
  if inch == v.len - 2:
    return parseInt(v[0..^3]) in 59 .. 76
  false

proc kvValid(k, v: string, verbose: bool = false): bool =
  const ranges = {
    byr: 1920 .. 2002,
    iyr: 2010 .. 2020,
    eyr: 2020 .. 2030
  }.toTable

  const eyeColours = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  try:
    let k = parseEnum[Fields](k)
    result = case k:
      of byr, iyr, eyr:
        parseInt(v) in ranges[k]
      of ecl:
        v in eyeColours
      of hgt:
        v.hgtValid()
      of hcl:
        v[0] == '#' and
        v[1..^1].len == 6 and
        v[1..^1].allIt(it in {'0'..'9', 'a'..'f'})
      of pid:
        v.len == 9 and
        v.allIt(it in {'0'..'9'})
      of cid:
        true
  except:
    if verbose: echo getCurrentExceptionMsg()
    result = false
  
  if verbose and not result:
    echo k
  

proc valid(pp: seq[string], verbose: bool = false): bool =

  proc toKV(pp: string): (string, string) =
    let kv = pp.split(":")
    (kv[0], kv[1])

  let kv = pp.map(toKV)

  reqFields(pp, true) and allIt(kv, kvValid(it[0], it[1], verbose))
  


proc eval(data: string): auto =
  
  let batches = toSeq(data.pp)

  let req = batches.filterIt( it.reqFields )

  echo req.len

  echo batches.filterIt(it.valid).len


proc main() =
  
  let data = todaysData(4)
  eval data

when isMainModule:
  main()

  let test = """ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"""

  let testInvalid = """eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007"""

  let testValid = """pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"""

  echo "\nfield test\n------------"
  for b in test.pp:
    echo b.reqFields true


  echo "\ninvalids\n------------"
  for b in testInvalid.pp:
    echo b.valid(true)

  echo "\nvalids\n------------"

  for b in testValid.pp:
    echo b.valid(true)
