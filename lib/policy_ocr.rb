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
        policy_number += get_number_from_pipes_and_underscores(segment[0..2].collect { |line| line[char_start..char_start+2] })
      end
      policy_numbers << policy_number
    end

    policy_numbers
  end

  def self.process_output_file(input_file, output_file=nil)
    policy_numbers = parse(input_file)
    
    # If no output file specified, create default output file input file
    output_file = input_file.sub(/\.[^.]+\z/, '') + '_output.txt' if output_file.nil?
    
    File.open(output_file, 'w') do |file|
      policy_numbers.each do |policy_number|
        file.puts "#{policy_number} #{is_valid_policy_number?(policy_number)}"
      end
    end
    
    output_file
  end

  # given a string of pipes and underscores, return the number it represents
  def self.get_number_from_pipes_and_underscores(combination)
    case combination
    when [' _ ',
          '| |',
          '|_|']
      '0'
    when ['   ',
          '  |',
          '  |']
      '1'
    when [' _ ',
          ' _|',
          '|_ ']
      '2'
    when [' _ ',
          ' _|',
          ' _|']
      '3' 
    when ['   ',
          '|_|',
          '  |']
      '4'
    when [' _ ',
          '|_ ',
          ' _|']
      '5'
    when [' _ ',
          '|_ ',
          '|_|']
      '6'
    when [' _ ',
          '  |',
          '  |']
      '7' 
    when [' _ ',
          '|_|',
          '|_|']
      '8'
    when [' _ ',
          '|_|',
          ' _|']
      '9'
    else
      '?'
    end
  end

  # given a policy number, return true if it is valid, false otherwise,
  # using where positions are d9-d1, corresponding with the policy number
  # and utizling the checksum calculation (d1+(2*d2)+(3*d3+...+(9*d9)) mod 11 = 0)
  def self.is_valid_policy_number?(policy_number)
    policy_number = policy_number.to_s if policy_number.is_a?(Integer)
    if policy_number.length != 9
      puts 'Policy number is not 9 numbers'
      return "ILL"
    elsif policy_number.include?('?')
      puts 'Policy number contains a ?'
      return "ILL"
    end
    
    sum = 0
    increment = 1
    # Get the sum for the formula d1+(2*d2)+(3*d3+...+(9*d9))
    (0..8).reverse_each do |i|
      sum += increment * policy_number[i].to_i
      increment += 1
    end
    
    if sum % 11 == 0
      return ""
    else
      return "ERR"
    end
  end
end
