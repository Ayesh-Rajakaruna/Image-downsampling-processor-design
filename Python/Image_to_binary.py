import cv2 as cv
def binareyconvertion(a):
    bnr = bin(a).replace('0b','')
    x = bnr[::-1]
    while len(x) < 8:
        x += '0'
    bnr = str(x[::-1])
    return bnr


img = cv.imread("C:\\Users\\Ayesh\\Desktop\\Project\\img\\img_in.png", cv.IMREAD_GRAYSCALE)
imagedata = []
for i in img:
    for j in i:
        imagedata.append(binareyconvertion(j))


hexfile = open ('BinaryOfImage.txt', 'w' )
count = 0
for l in imagedata :
    hexfile.write(f"DRAM[{count}] = 8'b{l};")
    hexfile.write("\n")
    count = count + 1
