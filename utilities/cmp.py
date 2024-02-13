import sys


sim=sys.argv[1]
machine=sys.argv[2]

f = open(sim, "r")
g = open(machine, "r")

f.readline()
g.readline()
f.readline()
g.readline()


i=2
s1 = f.readline()
s2 = g.readline()
while s1:   
    i+=1
    #print(i)
    #print(s1,s2)
    x = list(map(int, s1.split()[:3]))
    y = list(map(int, s2.split()[:3]))
    if x == y:
        pass
    else:
        print(f"line{i} : sim {x}, machine {y}")
    
    s1 = f.readline()
    s2 = g.readline()
f.close()
g.close()