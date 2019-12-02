#!/usr/bin/env ruby

def calculate_fuel(mass, total_fuel)
  fuel = (mass / 3.0).floor - 2
  return total_fuel if fuel <= 0

  calculate_fuel(fuel, total_fuel + fuel)
end

res = File.readlines(ARGV[0])
          .map { |l| calculate_fuel(l.to_i, 0) }
          .sum

puts(res)
