require 'rails_helper'

RSpec.describe Game, :type => :model do
  describe 'Validations' do
    it { should validate_presence_of(:word) }
    it { should validate_presence_of(:tries_left) }
    it { should validate_inclusion_of(:status).in_array(%w(busy fail success)) }
  end
  
  describe "Relations" do
    it { should belong_to(:word) }
  end
  
  describe 'Status' do
    it 'should have three states as constants' do
      expect(Game::STATUS).to eq(BUSY: 'busy', FAIL: 'fail', SUCCESS: 'success')
    end
  end
end
