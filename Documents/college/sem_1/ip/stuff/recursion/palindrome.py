def palindrome(s):

    if len(s) == 0 or len(s) == 1:
        return True
    elif s[0] == s[-1] and palindrome(s[1:-1]):
        return True
    else:
        return False


print(palindrome(""))
print(palindrome("$"))
print(palindrome("anna"))
print(palindrome("aditya"))
