class IntCodeComputer
  attr_reader :program

  def initialize(program)
    @instruction_counter = 0
    @program = program
  end

  def value_at(counter)
    @program[counter]
  end

  def op_at(counter, mode)
    if mode == 1
      value_at(counter)
    else
      position = @program[counter]
      value_at(position)
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

  def run
    while(true) 
      instruction = parse_instruction(@program[@instruction_counter])

      case instruction[:opcode]
      when 1
        op1     = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
        op2     = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
        target  = value_at(@instruction_counter + 3)

        @program[target] = op1 + op2
        @instruction_counter += 4
      when 2
        op1     = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
        op2     = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
        target  = value_at(@instruction_counter + 3)

        @program[target] = op1 * op2
        @instruction_counter += 4
      when 3
        target  = value_at(@instruction_counter + 1)

        print("Value> ")
        value = STDIN.gets.to_i
        @program[target] = value
        @instruction_counter += 2
      when 4
        value  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))

        puts(value)
        @instruction_counter += 2
      when 5
        op1  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
        jump = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))

        if op1 != 0
          @instruction_counter = jump
        else
          @instruction_counter += 3
        end
      when 6
        op1  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
        jump = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))

        if op1 == 0
          @instruction_counter = jump
        else
          @instruction_counter += 3
        end
      when 7
        op1  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
        op2  = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
        pos  = value_at(@instruction_counter + 3)

        if op1 < op2
          @program[pos] = 1
        else
          @program[pos] = 0
        end

        @instruction_counter += 4
      when 8
        op1  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
        op2  = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
        pos  = value_at(@instruction_counter + 3)

        if op1 == op2
          @program[pos] = 1
        else
          @program[pos] = 0
        end

        @instruction_counter += 4
      when 99
        break
      end
    end
  end
end
