#!/usr/bin/env ruby

res = File.readlines(ARGV[0])
          .map { |l| (l.to_i / 3.0).floor - 2 }
          .sum

puts(res)
