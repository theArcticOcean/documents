#!/usr/bin/python
import sys
import cv2
import numpy as np
import pytesseract

def image_resize(image, width = None, height = None, inter = cv2.INTER_AREA):
    dim = None
    (h, w) = image.shape[:2]

    if width is None and height is None:
        return image

    if width is None:
        r = height / float(h)
        dim = (int(w * r), height)
    else:
        r = width / float(w)
        dim = (width, int(h * r))

    resized = cv2.resize(image, dim, interpolation = inter)

    return resized

def get_grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

def thresholding(image):
    return cv2.threshold(image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

def WriteFile( filePath, content ):
    fobject = open( filePath, 'wb' )
    fobject.truncate()
    fobject.write(content.encode('utf-8'))
    fobject.close()

if __name__ == "__main__":
    img_path = ''
    langStr = 'eng'
    if len( sys.argv ) > 1:
            img_path = sys.argv[1]
    if len( sys.argv ) > 2:
            langStr = sys.argv[2]
    image = cv2.imread(cv2.samples.findFile(img_path))
    (h, w) = image.shape[:2]
    if w < 800:
        image = image_resize( image, width = 800 )
    if h < 800:
        image = image_resize( image, height = 800 )

    #cv2.imshow( "result", image )
    #cv2.waitKey( 0 )
    #exit( 1 )

    gray = get_grayscale(image)
    thresh = thresholding(gray)

    custom_config = r'--oem 3 --psm 6'
    result = pytesseract.image_to_string(thresh, lang=langStr, config=custom_config)
    WriteFile( 'ocr_result.txt', result )
    print(result.encode('utf-8'))
