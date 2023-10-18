def MinTime(T1, T2, T3):
    minT = T1
    if (T2 < minT):
        minT = T2
    if (T3 < minT): 
        minT = T3
    print(minT)
nextEvent = MinTime(15.0, 17.1, 26)
nextEvent = MinTime(17.1, 15.0, 26)
nextEvent = MinTime(17.1, 26, 15.0)
