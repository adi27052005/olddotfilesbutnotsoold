def min(t1,t2,t3,t4):

    min_num = t1
    if t2<t1:
        min_num = t2
    if t3<t2:
        min_num = t3
    if t4<t3:
        min_num = t4
    return min_num

print (min(4,3,2,1))
# NOTE: We do not use elif 
