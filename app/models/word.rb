class Word < ActiveRecord::Base
  validates_presence_of :text
  scope :random, -> { order('RANDOM()').first }
end
