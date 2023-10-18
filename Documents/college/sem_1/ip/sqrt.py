x = 3
epsilon = 0.0001
g = x/2
while abs(g*g-x) > epsilon:
    g = 0.5*(g+(x/g))
print (g)
