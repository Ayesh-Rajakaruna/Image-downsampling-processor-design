import cv2 as cv
import numpy as np
image = cv.imread("C:\\Users\\Ayesh\\Desktop\\Project\\img\\img_in.png", cv.IMREAD_GRAYSCALE)
kernel1 = np.array([[1, 2, 1]])
kernel2 = np.array([[1],
                    [2],
                    [1]])
kernel1 = kernel1/4
kernel2 = kernel2/4
identity1 = cv.filter2D(src=image, ddepth=-1, kernel=kernel1)
identity2 = cv.filter2D(src=identity1, ddepth=-1, kernel=kernel2)
print(kernel1)
print(" ")
print(image)
print(" ")
print(identity1)
for raw in range(len(identity2)):
    if raw%2 == 0:
        pass
    else:
        for colum in range(len(identity2[0])):
            if colum%2 == 0:
                pass
           # else:
               # print(identity2[colum][raw])


