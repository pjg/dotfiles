#!/usr/bin/env python3
from sys import argv
from sys import stdout


def ansicode(index):
  if index:
    return index * 40 + 55
  else:
    return 0

reset = argv[1:]
if reset:
  # colors 16-231 are a 6x6x6 color cube
  for red in range(6):
    redcode = ansicode(red)
    for green in range(6):
      greencode = ansicode(green)
      for blue in range(6):
        bluecode = ansicode(blue)
        stdout.write("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\" % (
          16 + 36*red + 6*green + blue,
          redcode, greencode, bluecode,
        ))

  # colors 232-255 are a grayscale ramp, intentionally leaving out
  # black and white
  for gray in range(24):
    level = gray * 10 + 8
    stdout.write("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
      232 + gray, level, level, level);

# display the colors
def white_fg():
  stdout.write("\x1b[1;38;5;231m")
def black_fg():
  stdout.write("\x1b[1;38;5;232m")

def show_color(color):
  stdout.write("\x1b[48;5;%sm %3i " % (color, color))

def reset(end='\n'):
  stdout.write("\x1b[0m" + end)

# first the system ones:
print("System colors:")
white_fg()
for color in range(8):
  if color == 7:
    black_fg()
  show_color(color)
reset()

white_fg()
for color in range(8, 16):
  if color == 9:
    black_fg()
  show_color(color)

reset('\n\n')

def luminance(r, g, b):
  # see: https://www.w3.org/TR/WCAG20-TECHS/G145.html#G145-tests
  if r <= 0.03928:
    r = r/12.92
  else:
    r = ((r+0.055)/1.055) ** 2.4

  if g <= 0.03928:
    g = g/12.92
  else:
    g = ((g+0.055)/1.055) ** 2.4

  if b <= 0.03928:
    b = b/12.92
  else:
    b = ((b+0.055)/1.055) ** 2.4
  return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast_ratio(l1, l2):
  # see: https://www.w3.org/TR/WCAG20-TECHS/G145.html#G145-tests
  if l1 < l2:
    l1, l2 = l2, l1
  ratio = (l1 + 0.05) / (l2 + 0.05)
  assert ratio >= 1, ratio
  return ratio


def show_rgb(red, green, blue):
  l = luminance(red/5, green/5, blue/5)
  if contrast_ratio(l, 0.0) > contrast_ratio(1, l):
    black_fg()
  else:
    white_fg()
  color = 16 + 36*red + 6*green + blue
  show_color(color)

# now the color cube
print("Color cube, 6x6x6: (256color)")
for red in range(6):
  for green in range(3):
    for blue in range(6):
      show_rgb(red, green, blue)
    reset(" ")
  print();
print()
for red in range(6):
  for green in range(3, 6):
    for blue in range(6):
      show_rgb(red, green, blue)
    reset(" ")
  print();


# now the grayscale ramp
print("Grayscale ramp:")
white_fg()
for color in range(232, 256):
  if color == 244:
    black_fg()
  show_color(color)
reset()
