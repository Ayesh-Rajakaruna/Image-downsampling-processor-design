import cv2 as cv
import numpy as np
image = cv.imread("C:\\Users\\Ayesh\\Desktop\\Project\\img\\img_in.png", cv.IMREAD_GRAYSCALE)

def convolution2d_X(image, kernel):
    y, x = image.shape
    new_image = np.zeros((y, x))
    for i in range(y):
        for j in range(x):
            if (j==0) or (j==x-1):
                new_image[i][j] = image[i][j]
            else:
                new_image[i][j] = np.sum(image[i, j-1:j+2] * kernel)
    return new_image

def convolution2d_Y(image, kernel):
    y, x = image.shape
    new_image = np.zeros((y, x))
    for i in range(y):
        for j in range(x):
            if (i==0) or (i==y-1):
                new_image[i][j] = image[i][j]
            else:
                new_image[i][j] = np.sum(image[i-1:i+2, j] * kernel)
    return new_image

kernel = np.array([1, 2, 1])/4
image_x = convolution2d_X(image, kernel)
image_y = convolution2d_Y(image_x, kernel)


lis_python = []
lis_vivado = []

file = open("C:\\Users\\Ayesh\\Desktop\\Project\\Processor\\SRC\\output.txt", 'r')
lines = file.readlines()

for i in range(64):
    for j in range(64):
        lis_python.append(image_y[i*2][j*2])

for i in range(len(lines)):
    lis_vivado.append(int(lines[i].strip()))

lis_python = np.array(lis_python)
lis_vivado = np.array(lis_vivado)

ssd = float(np.sum((lis_python - lis_vivado)**2))
print(ssd)
