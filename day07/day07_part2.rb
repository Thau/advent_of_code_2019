#!/usr/bin/env ruby

require_relative '../intcode_computer.rb'

class FakeInput
  attr_reader :inputs
  attr_reader :signal

  def initialize(inputs)
    @inputs = inputs
    @signal = 0
    @pointer = 0
  end

  def gets
    @inputs.pop
  end

  def puts(s)
    @inputs.unshift(s)
  end

  def to_s
    @inputs.inspect
  end
end


legal_inputs = [5, 6, 7, 8, 9]
permutations = legal_inputs.permutation

max_signal = 0
best_permutation = nil

program = File.read(ARGV[0]).split(',').map(&:to_i)

permutations.each do |permutation|
  STDOUT.puts "Testing permutation #{permutation.inspect}"

  signal = 0

  inputA = FakeInput.new([0, permutation[0]])
  inputB = FakeInput.new([permutation[1]])
  inputC = FakeInput.new([permutation[2]])
  inputD = FakeInput.new([permutation[3]])
  inputE = FakeInput.new([permutation[4]])

  ampA = IntCodeComputer.new(program.dup, inputA, inputB, false)
  ampB = IntCodeComputer.new(program.dup, inputB, inputC, false)
  ampC = IntCodeComputer.new(program.dup, inputC, inputD, false)
  ampD = IntCodeComputer.new(program.dup, inputD, inputE, false)
  ampE = IntCodeComputer.new(program.dup, inputE, inputA, false)

  until ampE.next_instruction[:opcode] == 99
    loop { ampA.step; break if ampA.last_instruction[:opcode] == 4 || ampA.next_instruction[:opcode] == 99 }
    loop { ampB.step; break if ampB.last_instruction[:opcode] == 4 || ampB.next_instruction[:opcode] == 99 }
    loop { ampC.step; break if ampC.last_instruction[:opcode] == 4 || ampC.next_instruction[:opcode] == 99 }
    loop { ampD.step; break if ampD.last_instruction[:opcode] == 4 || ampD.next_instruction[:opcode] == 99 }
    loop { ampE.step; break if ampE.last_instruction[:opcode] == 4 || ampE.next_instruction[:opcode] == 99 }
  end

  signal = inputA.inputs.last.to_i

  if signal > max_signal
    max_signal = signal
    best_permutation = permutation
  end
end

puts(max_signal)
puts(best_permutation.inspect)

