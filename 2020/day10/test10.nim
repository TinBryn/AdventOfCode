import main10

const
  testData1 = """16
10
15
5
1
11
7
19
6
12
4
"""

  testData2 = """28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

when isMainModule:
  echo eval1 testData1
  echo eval1 testData2

  echo eval2 testData1
  echo eval2 testData2