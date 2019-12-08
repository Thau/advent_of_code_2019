import os
import sequtils

const width = 25
const height = 6

let input = paramStr(1).readFile.toSeq
let num_layers = input.len div (width * height)

let layers = input.distribute(num_layers)

var min_zeros = high(int)
var ones_in_found_layer = 0
var twos_in_found_layer = 0

for layer in layers:
  var zeros = layer.count('0')

  if zeros < min_zeros:
    min_zeros = zeros
    ones_in_found_layer = layer.count('1')
    twos_in_found_layer = layer.count('2')

echo(ones_in_found_layer * twos_in_found_layer)
