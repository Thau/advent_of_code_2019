class IntCodeComputer
  attr_reader :program, :last_instruction

  def initialize(program, input = STDIN, output = STDOUT, prompt = true)
    @instruction_counter = 0
    @relative_base = 0
    @program = program
    @input = input
    @output = output
    @prompt = prompt
    @done = false
    @last_instruction = { opcode: 0, arg_modes: [] }
  end

  def grow_program(size)
    if size >= @program.length
      (size - @program.length + 1).times { @program << 0 }
    end
  end

  def value_at(counter)
    grow_program(counter)

    @program[counter]
  end

  def set(counter, value, mode)
    grow_program(counter)

    case mode
    when 2
      position = @relative_base + value_at(counter)
      @program[position] = value
    else
      position = value_at(counter)
      @program[position] = value
    end
  end

  def op_at(counter, mode)
    case mode
    when 1
      value_at(counter)
    when 2
      position = @relative_base + value_at(counter)
      value_at(position)
    else
      position = value_at(counter)
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

  def next_instruction
    parse_instruction(@program[@instruction_counter])
  end

  def step
    instruction = next_instruction

    case instruction[:opcode]
    when 1
      op1     = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
      op2     = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
      target  = @instruction_counter + 3

      set(target, op1 + op2, instruction[:arg_modes].fetch(2, 0))
      @instruction_counter += 4
    when 2
      op1     = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
      op2     = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
      target  = @instruction_counter + 3

      set(target, op1 * op2, instruction[:arg_modes].fetch(2, 0))
      @instruction_counter += 4
    when 3
      print("Value> ") if @prompt
      value = @input.gets.to_i

      target  = @instruction_counter + 1

      set(target, value, instruction[:arg_modes].fetch(0, 0))
      @instruction_counter += 2
    when 4
      value  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))

      @output.puts(value)
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
      pos  = @instruction_counter + 3

      if op1 < op2
        set(pos, 1, instruction[:arg_modes].fetch(2, 0))
      else
        set(pos, 0, instruction[:arg_modes].fetch(2, 0))
      end

      @instruction_counter += 4
    when 8
      op1  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
      op2  = op_at(@instruction_counter + 2, instruction[:arg_modes].fetch(1, 0))
      pos  = @instruction_counter + 3

      if op1 == op2
        set(pos, 1, instruction[:arg_modes].fetch(2, 0))
      else
        set(pos, 0, instruction[:arg_modes].fetch(2, 0))
      end

      @instruction_counter += 4
    when 9
      op1  = op_at(@instruction_counter + 1, instruction[:arg_modes].fetch(0, 0))
      @relative_base += op1

      @instruction_counter += 2
    when 99
      @done = true
    end

    @last_instruction = instruction
  end

  def run
    while(!@done)
      step
    end
  end
end
