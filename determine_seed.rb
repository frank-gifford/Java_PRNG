#!/usr/bin/env ruby

# Copyright 2019, Frank Gifford
# This program is free to use for any purpose without restrictions.

# A helper program to reverse engineer Java's PRNG seed used in
# creating passwords.
#
# Dependencies: JavaCG is required for this to work.
# https://github.com/votadlos/JavaCG


if ((ARGV.size != 2) || (ARGV[0] == "-h"))
  puts "Given an alphabet and a password generated by Java's PRNG,"
  puts "determine the seed that's used to create it."
  puts
  puts "Note that javacg needs to be part of PATH, i.e."
  puts
  puts "kali# PATH=$PATH:/root/code/JavaCG-master/JavaCG/Release ./determine_seed.rb ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 FI7CTQsBDvsMwbQNyY6qxV2FunWIUpXpcZm"
  puts "Found seed: 89560454678953"
  puts "Verify with: java generate_password ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 89560454678953 35"
  exit -1
end


alphabet = ARGV[0]
target = ARGV[1]


# Given a current PRNG seed, step backwards in the sequence
def step_back(seed, amt)
  multiplier = 0x5DEECE66D;	# Java's PRNG multiplier
  inv_mult = 0xDFE05BCB1365;	# Multiplicative inverse
  increment = 0xB;		# Java's PRNG constant
  mod = (1 << 48);		# Java's modulus

  amt.times {
    seed = ((mod + seed - increment) * inv_mult) % mod;
  }
  seed
end


# The external program expects the human to type in a sequence of 
# integers from the standard inputs.  This method converts the 
# target password to the sequence of integers and pipes them through.
def get_seed(modulus, target)
  cmd = "javacg -n #{target.size} -l #{modulus}"

  seed = nil
  IO.popen(cmd, "r+") do |pipe|
    target.each { |i| pipe.puts i }
    pipe.close_write

    # Look for an answer
    while (true)
      str = pipe.gets
      if (str =~ /Next seed = (\d*)$/)
        return($1.to_i)
      elsif (str =~ /Seed not found/)
        puts "Seed is not found: too short or not Java PRNG."
        exit -1
      end
    end
  end
end


# A simple helper method to convert a password character to integer.
def target_to_int(alphabet, target)
  target.split(//).map { |ch| 
    v = alphabet.index(ch)
    if (v == nil)
      puts "Password character '#{ch}' is not part of alphabet"
      exit -1
    end
    v
  }
end


# Convert the target to a sequence of integers for javacg program.
target_ints = target_to_int(alphabet, target)

# Use external program to figure out the seed for the PRNG sequence.
seed = get_seed(alphabet.size, target_ints)

# Now have seed after password, need to rewind it to the start.
seed = step_back(seed, target.size)

# The seed supplied to Java's class is XORed with a constant, fix that.
seed ^= 0x5DEECE66D

puts "Found seed: #{seed}"
puts "Verify with: java generate_password #{alphabet} #{seed} #{target.size}"

exit 0
