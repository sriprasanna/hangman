class Game < ActiveRecord::Base
  STATUS = {BUSY: 'busy', FAIL: 'fail', SUCCESS: 'success'}
  DOT = '.'
  belongs_to :word
  validates_presence_of :word, :tries_left
  validates_inclusion_of :status, :in => Game::STATUS.values
  before_create :generate_current_word_status
  
  def play letter
    return if game_ended?
    indexes = get_indexes_of_letter letter
    if indexes.blank?
      decrement_number_of_tries
    else
      modify_word_status indexes, letter
    end
    decide!
  end
  
  private
  def generate_current_word_status
    self.current_word_status = DOT * word.text.length
  end
  
  def get_indexes_of_letter letter
    text = word.text
    (0..text.length).find_all do |index|
      text[index, 1] == letter
    end
  end
  
  def modify_word_status indexes, letter
    new_word_status = self.current_word_status.dup
    indexes.each do |index|
      new_word_status[index, 1] = letter
    end
    self.current_word_status = new_word_status
  end
  
  def decrement_number_of_tries
    self.tries_left -= 1
  end
  
  def decide!
    if not self.current_word_status.include? Game::DOT
      self.status = STATUS[:SUCCESS]
    elsif self.tries_left == 0
      self.status = STATUS[:FAIL]
    end
    save!
  end
  
  def game_ended?
    self.status != STATUS[:BUSY]
  end
end
