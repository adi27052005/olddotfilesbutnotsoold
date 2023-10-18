A1 = 80
B1 = 3

def is_power(A1,B1):
    if A1>1 and 1<B1<=A1:
        if A1==B1:
            return True
        elif A1%B1==0 and is_power(A1/B1,B1):
            return True
        else:
            return False

print(is_power(A1,B1))
