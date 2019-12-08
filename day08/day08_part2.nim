import os
import sequtils
import strutils
import algorithm
import sugar

const width = 25
const height = 6

let input = paramStr(1).readFile.strip.map(c => c)
let num_layers = input.len div (width * height)

var layers = input.distribute(num_layers, false)
layers.reverse()

var finalImage = newSeq[char](layers[0].len)

for layer in layers:
  for i, pixel in pairs(layer):
    if pixel != '2':
      finalImage[i] = pixel

for i, pixel in pairs(finalImage):
  if i mod width == 0:
    stdout.write '\n'

  if pixel == '1':
    stdout.write "█"
  else:
    stdout.write " "
