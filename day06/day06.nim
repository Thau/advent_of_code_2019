import os
import sequtils
import strutils

type 
  Planet = ref object
    name: string
    orbited_by: seq[Planet]

proc find_planet(root: Planet, name: string): Planet =
  if root.name == name:
    return root

  for orbiting_planet in root.orbited_by:
    if orbiting_planet.name == name:
      return orbiting_planet 
      
    let candidate = find_planet(orbiting_planet, name)

    if candidate != nil:
      return candidate

var input = to_seq(lines paramStr(1))

for i, orbit in pairs(input):
  if orbit.starts_with("COM"):
    input.delete(i, i)
    input.insert([orbit], 0)
    break

var remaining_planets_to_parse = input

var orbits: Planet

# This way of parsing is naive as hell, and slow, but works and I'm tired and lazy today :P
while remaining_planets_to_parse != @[]:
  var new_remaining: seq[string] = @[]

  for orbit in remaining_planets_to_parse:
    let sp = orbit.split(")")
    let base_planet_name = sp[0]
    let orbiting_planet_name = sp[1]

    let orbiting_planet = Planet(name: orbiting_planet_name, orbited_by: @[])

    let base_planet = if orbits == nil:
      let new_planet = Planet(name: base_planet_name, orbited_by: @[])
      orbits = new_planet
      new_planet
    else:
      find_planet(orbits, base_planet_name)

    if base_planet == nil:
      new_remaining.add(orbit)
    else:
      base_planet.orbited_by.add(orbiting_planet)

  remaining_planets_to_parse = new_remaining

proc calculate_connections(planet: Planet, depth: int): int =
  var new_depth = depth + 1
  var new_connections = 0

  for orbiting_planet in planet.orbited_by:
    new_connections += calculate_connections(orbiting_planet, new_depth)

  return new_connections + depth

echo(calculate_connections(orbits, 0))
