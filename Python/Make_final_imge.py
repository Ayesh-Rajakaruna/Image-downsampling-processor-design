import cv2 as cv
import numpy as np

file = open("C:\\Users\\Ayesh\\Desktop\\Project\\Processor\\SRC\\output.txt", 'r')
lines = file.readlines()
Binary = []
image = np.full((64, 64), 0, dtype=np.uint8)

for i in range(len(lines)):
    Binary.append(int((lines[i].strip())))

for raw in range(64):
    for colum in range(64):
        index = raw * 64 + colum
        image[raw][colum] = Binary[index]


imorginal = cv.imread("C:\\Users\\Ayesh\\Desktop\\Project\\img\\img_in.png")
cv.imwrite("C:\\Users\\Ayesh\\Desktop\\Project\\img\\img_out.png", image)

hexfile = open('Output.txt', 'w')
imagedata = []
for i in image:
    for j in i:
        hexfile.write(str(j))
        hexfile.write("\n")

print(imorginal)
print(image)


