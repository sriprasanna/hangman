require 'rails_helper'

RSpec.describe Word, :type => :model do
  describe 'Validations' do
    it { should validate_presence_of(:text) }
  end
end
