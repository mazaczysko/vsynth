import binascii

max_val = 65535

for i in range(0,255):
    if i == 0 :
        div = max_val
    else:
        div = round(max_val/i)
    print(format(div, '04x'))