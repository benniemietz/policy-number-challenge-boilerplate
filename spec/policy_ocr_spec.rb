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
        ["00??000?0", "1111?1111", "22???222?"]
      )
    end

    it 'returns an error if the file is not found' do 
      expect { PolicyOcr.parse('not_a_file.txt') }.to raise_error(Errno::ENOENT)
    end
  end 
end
