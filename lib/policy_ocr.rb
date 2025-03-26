require 'pry'

module PolicyOcr

  # given a file, parse the file and return an array of policy numbers
  def self.parse(input_file)
    policy_numbers = []
    
    begin
      content = File.read(input_file)
    rescue Errno::ENOENT
      puts "File not found: #{input_file}"
      raise
    end 
    
    # split the content into segments of 4 lines
    segments = content.split("\n").each_slice(4) 

    # iterate over each segment, expecting the segments to create 9 numbers, each segment has top, middle, bottom, and empty line, that generates a number 0-9
    segments.each do |segment|
      policy_number = ''
      (0..8).each do |i|
        char_start = i*3 # each top, middle, and bottom is 3 chars so we need to get the start of each top, middle, and bottom
        policy_number += self.get_number_from_pipes_and_underscores(segment[0..2].collect { |line| line[char_start..char_start+2] }.join)
      end
      policy_numbers << policy_number
    end

    policy_numbers
  end

  # given a string of pipes and underscores, return the number it represents
  def self.get_number_from_pipes_and_underscores(combination)
    case combination
    when ' _ | ||_|'
      '0'
    when '     |  |'
      '1'
    when ' _  _||_ '
      '2'
    when ' _  _| _|'
      '3' 
    when '   |_|  |'
      '4'
    when ' _ |_  _|'
      '5'
    when ' _ |_ |_|'
      '6'
    when ' _   |  |'
      '7' 
    when ' _ |_||_|'
      '8'
    when ' _ |_| _|'
      '9'
    else
      '?'
    end
  end
end
