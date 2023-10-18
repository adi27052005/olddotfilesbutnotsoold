def minnum(t1,t2,t3,t4):
    mint = t1
    if t1 > t2:
        mint = t2
    if t2 > t3:
        mint = t3
    if t3 > t4:
        mint = t4
    return mint
print (minnum(4,3,4,7))
