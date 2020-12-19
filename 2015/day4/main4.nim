import md5

const input = "ckczppom"

var c = 0
while true:
  let s = input & $c
  let d = s.toMD5
  if ($d)[0..5] == "000000":
    echo d
    break
  inc c
  if c mod 1000000 == 0:
    echo c div 1000000

echo c
