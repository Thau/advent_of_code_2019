const range = 265275..781584

proc get_next_digit(num: int): (int, int) =
  result = (num mod 10, num div 10)

proc is_increasing(starting_number: int): bool =
  # Start assuming it's going to be true
  result = true
  var num:int
  var previous_digit:int
  var digit:int

  (previous_digit, num) = get_next_digit(starting_number)

  for _ in countup(0, 5):
    (digit, num) = get_next_digit(num)

    if digit > previous_digit:
      result = false 

    previous_digit = digit

proc two_equal_adjacent(number: int): bool =
  result = false
  var num:int
  var previous_digit:int
  var digit:int
  var group_size = 1

  (previous_digit, num) = get_next_digit(number)

  for _ in countup(0, 5):
    (digit, num) = get_next_digit(num)

    if digit == previous_digit:
      group_size += 1
    else:
      if group_size == 2:
        return true
      else:
        group_size = 1

    previous_digit = digit

var count = 0

for i in range:
  if not is_increasing(i):
    continue

  if not two_equal_adjacent(i):
    continue

  count += 1

echo count

