def toh(n,start,aux,end):
    if n==1:
        print(f"Move disc {n} from {start} to {end}")
        return
    toh(n-1,start,end,aux)
    print(f"Move disc {n} from {start} to {end}")
    toh(n-1,aux,start,end)
toh(3,"A","B","C")

