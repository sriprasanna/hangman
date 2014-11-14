require 'rails_helper'

RSpec.describe Word, :type => :model do
  describe 'Validations' do
    it { should validate_presence_of(:text) }
  end
  
  describe 'Random' do
    it 'should return random record from the DB' do
      expected_result = Word.new
      Word.stub(:order).with("RANDOM()").and_return([expected_result])
      expect(Word.random).to eq(expected_result)
    end
  end
end
