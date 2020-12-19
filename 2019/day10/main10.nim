import ../utils

type AsteroidField* = Array2D[char]

proc loadField*(data: seq[string]): AsteroidField =
  for line in data:
    result.data.add line
    result.width = line.len

  

proc eval(data: string) =
  echo data[0..100]



let data = readFile("2019/day10/data10")

eval data
