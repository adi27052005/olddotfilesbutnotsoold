def gcd(a, b):
    if a % b == 0:
        return b
    else:
        return gcd(b, a % b)


print(gcd(15, 6))

# it can also be represented as gcd(a-b, b)
