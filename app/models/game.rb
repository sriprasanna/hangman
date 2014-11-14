class Game < ActiveRecord::Base
  STATUS = {BUSY: 'busy', FAIL: 'fail', SUCCESS: 'success'}
  belongs_to :word
  validates_presence_of :word, :tries_left
  validates_inclusion_of :status, :in => Game::STATUS.values
end
