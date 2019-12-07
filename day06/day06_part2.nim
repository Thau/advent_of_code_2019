import os
import sequtils
import strutils

type 
  Planet = ref object
    name: string
    orbits: Planet
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
      orbiting_planet.orbits = base_planet
      base_planet.orbited_by.add(orbiting_planet)

  remaining_planets_to_parse = new_remaining

let you = find_planet(orbits, "YOU")

proc find_santa(planet: Planet, depth: int, visited: seq[string]): void =
  if planet.name == "SAN":
    echo("Jumped to SAN in ", depth - 2, " jumps")
    return 

  if visited.find(planet.name) != -1:
    return

  var new_visited = visited
  new_visited.add(planet.name)

  var move_candidates = planet.orbited_by

  if planet.orbits != nil:
    move_candidates.add(planet.orbits)

  for orbiting_planet in move_candidates:
    find_santa(orbiting_planet, depth + 1, new_visited) 

find_santa(you, 0, @[])
