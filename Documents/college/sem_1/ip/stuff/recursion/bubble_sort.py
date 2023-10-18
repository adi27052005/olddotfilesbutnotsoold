l = [1,3,4,6,7,8,10,13,14,18,19,21,24,37,40,45,71]
a = 10
def search(l):
    if (l[len(l)//2]) == a:
        print (a)
        print("Int Found")
        exit()
    elif (l[len(l)//2]) > a:
        l = l[:len(l)//2]
    elif (l[len(l)//2]) < a:
        l = l[(len(l)//2)+1:]
    search(l)

search(l)
