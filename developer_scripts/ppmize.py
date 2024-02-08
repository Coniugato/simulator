import sys
mode="P3"
with open(sys.argv[1], "r") as f:
    lines=f.read().split()
#print(lines)
with open(sys.argv[1], "w") as f:
    print("P3",file=f)
    print(lines[3], lines[5], lines[7], file=f)
    index=9
    while index+5<len(lines):
        print(lines[index+0],lines[index+2],lines[index+4], file=f)
        #print(index, len(lines))
        #print(lines[index+1],lines[index+3],lines[index+5])
        index+=6


    
