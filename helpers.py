#!/usr/bin/python2
from optparse import OptionParser

def strHex(x):
    return "%0.2X" % x

def getColor(arg):
    print('getColor')
    print(arg)
    arg = int(arg)

    red = 0
    green = 0
    if arg > 50:
        red = 255
        green = (100 - arg) * 2.55
    else:
        green = 255
        red = arg * 2.55

    blue = '00'
    return '\#' + strHex(red) + strHex(green) + blue


# ========== MAIN ==========
parser = OptionParser()
parser.add_option("-c", "--color", default=100)

(options, args) = parser.parse_args()

if hasattr(options, 'color'):
    return getColor(options.color)
else
    return '#FF0000'
