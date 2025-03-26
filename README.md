# Kin Ruby Project

This is a simple Ruby project for the Kin Assessment.

## Ruby Version

This project uses Ruby 3.4.2. You can check your Ruby version with:
```bash
ruby -v
```

## Running the project

To run the project, use the following command:
```bash
bundle exec irb -r ./lib/policy_ocr.rb
3.3.6 :001 > PolicyOcr.is_valid_policy_number?(457508000)
 => true 
3.3.6 :002 > PolicyOcr.is_valid_policy_number?(4575080)
 => false 
3.3.6 :003 > PolicyOcr.parse(File.join(File.dirname(__FILE__), 'spec/fixtures/bad_sample.txt'))
 => ["00??000?0", "1111?1111", "22???222?"] 
```

To run the tests, use the following command:
```bash
bundle exec rspec
```