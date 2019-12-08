#!/usr/bin/env ruby

require 'stringio'
require_relative '../intcode_computer.rb'

class FakeInput
  def initialize(inputs)
    @inputs = inputs
  end

  def gets
    @inputs.pop.to_s
  end
end


legal_inputs = [0, 1, 2, 3, 4]
permutations = legal_inputs.permutation

max_signal = 0
best_permutation = nil

permutations.each do |permutation|
  signal = 0

  permutation.each do |phase|
    program = File.read(ARGV[0]).split(',').map(&:to_i)
    input = FakeInput.new([signal, phase])
    output = StringIO.new

    computer = IntCodeComputer.new(program, input, output)

    computer.run

    signal = output.string.to_i
  end

  if signal > max_signal
    max_signal = signal
    best_permutation = permutation
  end
end

puts(max_signal)
puts(best_permutation.inspect)
