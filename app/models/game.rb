class Game < ActiveRecord::Base
  belongs_to :word
  validates_presence_of :word, :tries_left
  validates_inclusion_of :status, :in => %w( busy fail success )
end
