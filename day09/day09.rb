#!/usr/bin/env ruby

require_relative '../intcode_computer.rb'

program = File.read(ARGV[0]).split(',').map(&:to_i)
computer = IntCodeComputer.new(program)

computer.run
