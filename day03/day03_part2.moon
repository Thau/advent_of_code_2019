#!/usr/bin/env moon

split_commas = (line) ->
  [word for word in string.gmatch(line, '([^,]+)')]

wire_instructions_to_positions = (wire) ->
  x = 0
  y = 0
  steps = 1

  positions = { }

  for instruction in *wire
    direction = instruction\sub(1,1)
    distance = tonumber(instruction\sub(2))

    switch direction
      when "U"
        for i=y+1,(y+distance)
          data_point = { x: x, y: i, steps: steps }
          positions["x:#{x} y:#{i}"] = data_point if positions["x:#{x} y:#{i}"] == nil
          steps += 1

        y = y + distance
      when "D"
        for i=y-1,(y-distance),-1
          data_point = { x: x, y: i, steps: steps }
          positions["x:#{x} y:#{i}"] = data_point if positions["x:#{x} y:#{i}"] == nil
          steps += 1

        y = y - distance
      when "R"
        for i=x+1,(x+distance)
          data_point = { x: i, y: y, steps: steps }
          positions["x:#{i} y:#{y}"] = data_point if positions["x:#{i} y:#{y}"] == nil
          steps += 1

        x = x + distance
      when "L"
        for i=x-1,(x-distance),-1
          data_point = { x: i, y: y, steps: steps }
          positions["x:#{i} y:#{y}"] = data_point if positions["x:#{i} y:#{y}"] == nil
          steps += 1

        x = x - distance

  positions

lines = io.lines(arg[1])
wires = [wire_instructions_to_positions(split_commas(line)) for line in lines]

-- Using Lua 5.1 here, so no access to math.maxinteger
min_steps = 1000000000000000000

for key, {x: x, y: y, steps: steps} in pairs(wires[1])
  candidate = wires[2][key]

  if candidate
    sum = steps + candidate.steps
    min_steps = sum if sum > 0 and sum < min_steps

print(min_steps)
