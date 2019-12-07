#!/usr/bin/env ruby

require_relative '../intcode_computer.rb'

def program_with_changed_values(val_1, val_2)
  file = ARGV[0]
  program = File.read(file).split(',').map(&:to_i)
  program[1] = val_1
  program[2] = val_2
  program
end


program = program_with_changed_values(0, 0)
max = program.length
objective = 19690720

# Naive exhaustive search because the program space is short: Values can only be addresses that fit in the already loaded program
(0...max).each do |x|
  (0...max).each do |y|
    program = program_with_changed_values(x, y)
    computer = IntCodeComputer.new(program)
    computer.run

    if computer.program[0] == objective
      puts(computer.program.inspect)
      exit
    end
  end
end
