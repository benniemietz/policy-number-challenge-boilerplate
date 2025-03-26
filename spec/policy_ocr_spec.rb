require_relative '../lib/policy_ocr'

describe PolicyOcr do
  it "loads" do
    expect(PolicyOcr).to be_a Module
  end

  it 'loads the sample.txt' do
    expect(fixture('sample').lines.count).to eq(44)
  end

  describe 'parse' do 
    it 'parses the sample.txt' do
      expect(PolicyOcr.parse(File.join(File.dirname(__FILE__), 'fixtures/sample.txt'))).to eq(
        ['000000000', '111111111', '222222222', '333333333', '444444444', '555555555', '666666666', '777777777', '888888888', '999999999', '123456789']
      )
    end

    it 'parses the bad_sample.txt' do 
      expect(PolicyOcr.parse(File.join(File.dirname(__FILE__), 'fixtures/bad_sample.txt'))).to eq(
        ["00??000?0", "1111?1111", "?2???222?"]
      )
    end

    it 'returns an error if the file is not found' do 
      expect { PolicyOcr.parse('not_a_file.txt') }.to raise_error(Errno::ENOENT)
    end
  end 

  describe 'process_output_file' do 
    it 'processes the sample.txt' do 
      expect(PolicyOcr.process_output_file(File.join(File.dirname(__FILE__), 'fixtures/sample.txt'))).to eq(File.join(File.dirname(__FILE__), 'fixtures/sample_output.txt'))
    end
  end 

  describe 'process_output_file' do 
    it 'processes the sample.txt' do 
      expect(PolicyOcr.process_output_file(File.join(File.dirname(__FILE__), 'fixtures/bad_sample.txt'))).to eq(File.join(File.dirname(__FILE__), 'fixtures/bad_sample_output.txt'))
    end
  end

  describe 'get_number_from_pipes_and_underscores' do 
    it 'returns the number from the pipes and underscores' do 
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              '| |',
                                                              '|_|'])).to eq('0')
      expect(PolicyOcr.get_number_from_pipes_and_underscores(['   ',
                                                              '  |',
                                                              '  |'])).to eq('1')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              ' _|',
                                                              '|_ '])).to eq('2')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              ' _|',
                                                              ' _|'])).to eq('3')
      expect(PolicyOcr.get_number_from_pipes_and_underscores(['   ',
                                                              '|_|',
                                                              '  |'])).to eq('4')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              '|_ ',
                                                              ' _|'])).to eq('5')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              '|_ ',
                                                              '|_|'])).to eq('6')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              '  |',
                                                              '  |'])).to eq('7')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              '|_|',
                                                              '|_|'])).to eq('8')
      expect(PolicyOcr.get_number_from_pipes_and_underscores([' _ ',
                                                              '|_|',
                                                              ' _|'])).to eq('9')
    end
  end

  describe 'is_valid_policy_number?' do 
    it 'accepts an integer' do 
      expect(PolicyOcr.is_valid_policy_number?(457508000)).to eq('')
    end

    it 'accepts a string' do 
      expect(PolicyOcr.is_valid_policy_number?('457508000')).to eq('')
    end

    it 'returns false if the policy number is not 9 digits' do 
      expect(PolicyOcr.is_valid_policy_number?('45750800')).to eq('ILL')
    end

    it 'returns false if the policy number contains a ?' do 
      expect(PolicyOcr.is_valid_policy_number?('45750800?')).to eq('ILL')
    end

    it 'returns true if the policy number is valid' do 
      expect(PolicyOcr.is_valid_policy_number?('457508000')).to eq('')
    end

    it 'returns false if the policy number is invalid' do 
      expect(PolicyOcr.is_valid_policy_number?('664371495')).to eq('ERR')
    end
  end
end
