#!/usr/bin/env moon

split_commas = (line) ->
  [word for word in string.gmatch(line, '([^,]+)')]

-- No subtraction because we only want the Manhattan distance from the central port which is at 0, 0
manhattan = (x, y) ->
  math.abs(x) + math.abs(y)

wire_instructions_to_positions = (wire) ->
  x = 0
  y = 0

  positions = { }

  for instruction in *wire
    direction = instruction\sub(1,1)
    distance = tonumber(instruction\sub(2))

    switch direction
      when "U"
        for i=y,(y+distance)
          data_point = { x: x, y: i, distance: manhattan(x, i) }
          positions["x:#{x} y:#{i}"] = data_point

        y = y + distance
      when "D"
        for i=y,(y-distance),-1
          data_point = { x: x, y: i, distance: manhattan(x, i) }
          positions["x:#{x} y:#{i}"] = data_point

        y = y - distance
      when "R"
        for i=x,(x+distance)
          data_point = { x: i, y: y, distance: manhattan(i, y) }
          positions["x:#{i} y:#{y}"] = data_point

        x = x + distance
      when "L"
        for i=x,(x-distance),-1
          data_point = { x: i, y: y, distance: manhattan(i, y) }
          positions["x:#{i} y:#{y}"] = data_point

        x = x - distance

  positions

lines = io.lines(arg[1])
wires = [wire_instructions_to_positions(split_commas(line)) for line in lines]

wire1 = wires[1]
wire2 = wires[2]
intersections = {}

for key, {x: x, y: y, distance: distance} in pairs(wire1)
  candidate = wire2[key]

  if candidate
    intersections[#intersections + 1] = candidate

-- Using Lua 5.1 here, so no access to math.maxinteger
min_distance = 1000000000000000000

for {x: x, y: y, distance: distance} in *intersections
  min_distance = distance if distance != 0 and distance < min_distance

print(min_distance)
