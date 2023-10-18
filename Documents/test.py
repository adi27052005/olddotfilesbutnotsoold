a = [1,2,3]
b = [1,2,3]

print (a,b)
print (b is a)

a = b # aliasing
print (b is a)

b[0] = 11
print (a,b)
print(b is a)

c = "banana"
d = "banana"
print(  )
print( c is d )
d = "B" + d[1:]
print(d)
print ( c is d )

print(  )

techs = ['MIT', 'Caltech']
ivys = ['Harvard', 'Yale', 'Brown']
univs = [techs, ivys]
# univs1 = [['MIT','Caltech'], ['Harvard', 'Yale', 'Brown']]
# print(univs is univs1)
# the two lists have the same value so univs == univs1 is true but they are stored in different places in the memory so univs is univs1 is false

univs1 = univs
print(univs is univs1)

