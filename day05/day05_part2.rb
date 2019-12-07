#!/usr/bin/env ruby

require_relative '../intcode_computer.rb'

file = ARGV[0]

program = File.read(file).split(',').map(&:to_i)

IntCodeComputer.new(program).run
