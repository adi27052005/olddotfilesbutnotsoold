# Upper case letters range from 65-90
# 0 < k < 26

def ceaser(k,s):
    if s=="":
        print("")
        break
    for i in s:
        if ord(i) >= 65 and ord(i) <= 90 and k >= 0 and k <= 26:
            print(something(k,s))
            break
        else:
            print("Invalid Input")
            break

def something(k,s):
    s_out = ""
    for i in s:
        if ord(i)+k > 90:
            s_out += chr(ord(i)+k-91+65)
        else:
            s_out += chr(ord(i)+k)
    return s_out
    

ceaser(5,"WORLD")
