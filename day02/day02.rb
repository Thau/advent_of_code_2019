#!/usr/bin/env ruby

file = ARGV[0]

program = File.read(file).split(',').map(&:to_i)

instruction_counter = 0

while(true) 
  opcode = program[instruction_counter]

  case opcode
  when 1
    op1 = program[program[instruction_counter + 1]]
    op2 = program[program[instruction_counter + 2]]
    target = program[instruction_counter + 3]
    program[target] = op1 + op2
  when 2
    op1 = program[program[instruction_counter + 1]]
    op2 = program[program[instruction_counter + 2]]
    target = program[instruction_counter + 3]
    program[target] = op1 * op2
  when 99
    puts(program.inspect)
    break
  end

  instruction_counter += 4
end
