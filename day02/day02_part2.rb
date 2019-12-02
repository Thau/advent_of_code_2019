#!/usr/bin/env ruby

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
        if program[0] == objective
          puts(program.inspect)
          exit
        end
        break
      end

      instruction_counter += 4
    end
  end
end
