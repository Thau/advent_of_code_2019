#!/usr/bin/env ruby

require_relative '../intcode_computer.rb'

file = ARGV[0]

program = File.read(file).split(',').map(&:to_i)

computer = IntCodeComputer.new(program)
computer.run
puts(computer.program[0])
