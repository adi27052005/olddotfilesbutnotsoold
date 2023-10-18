s = "abcbsdsa"

def pal(s):
    if len(s)==1 or len(s)==0:
        return True
    elif s[0]==s[-1] and pal(s[1:-1]):
        return True
    else:
        return False
print (pal(s))
