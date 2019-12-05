#!/usr/bin/env ruby

file = ARGV[0]

program = File.read(file).split(',').map(&:to_i)

instruction_counter = 0

def value_at(program, counter)
  program[counter]
end

def op_at(program, counter, mode)
  if mode == 1
    value_at(program, counter)
  else
    position = program[counter]
    value_at(program, position)
  end
end

def parse_instruction(instruction)
  opcode = instruction % 100
  rest = instruction / 100
  arg_modes = []

  while(rest != 0)
    arg_modes << (rest % 10)
    rest = rest / 10
  end

  { opcode: opcode, arg_modes: arg_modes }
end

while(true) 
  instruction = parse_instruction(program[instruction_counter])

  case instruction[:opcode]
  when 1
    op1     = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
    op2     = op_at(program, instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
    target  = value_at(program, instruction_counter + 3)

    program[target] = op1 + op2
    instruction_counter += 4
  when 2
    op1     = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
    op2     = op_at(program, instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
    target  = value_at(program, instruction_counter + 3)

    program[target] = op1 * op2
    instruction_counter += 4
  when 3
    target  = value_at(program, instruction_counter + 1)

    print("Value> ")
    value = STDIN.gets.to_i
    program[target] = value
    instruction_counter += 2
  when 4
    value  = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))

    puts(value)
    instruction_counter += 2
  when 5
    op1  = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
    jump = op_at(program, instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))

    if op1 != 0
      instruction_counter = jump
    else
      instruction_counter += 3
    end
  when 6
    op1  = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
    jump = op_at(program, instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))

    if op1 == 0
      instruction_counter = jump
    else
      instruction_counter += 3
    end
  when 7
    op1  = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
    op2  = op_at(program, instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
    pos  = value_at(program, instruction_counter + 3)

    if op1 < op2
      program[pos] = 1
    else
      program[pos] = 0
    end

    instruction_counter += 4
  when 8
    op1  = op_at(program, instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
    op2  = op_at(program, instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
    pos  = value_at(program, instruction_counter + 3)

    if op1 == op2
      program[pos] = 1
    else
      program[pos] = 0
    end

    instruction_counter += 4
  when 99
    puts(program.inspect)
    break
  end
end


