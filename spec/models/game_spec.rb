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
    
  describe 'Tries' do
    it 'should have default number of tries' do
      expect(Game.new.tries_left).to eq(11)
    end
  end
  
  describe 'Actions' do
    let(:word){
      Word.create! text: 'awesome'
    }
    
    let(:game){
      Game.create! word: word, status: Game::STATUS[:BUSY]
    }

    describe 'Current word status' do
      it 'should have the current word as dots after creation' do
        expect(game.current_word_status).to eq(Game::DOT * word.text.length)
      end
    end
    
    describe 'To JSON' do
      it 'should generate hash with relevant data' do
        expect(game.to_json).to eq({id: game.id, word: game.current_word_status, tries_left: game.tries_left, status: game.status}.to_json)
      end
    end
    
    
    describe 'Play' do
      it 'should have the letters revealed when a correct guess is made' do
        game.play 'e'
        game.reload
        game.play 'a'
        game.reload
        expect(game.current_word_status).to eq('a.e...e')
        expect(game.tries_left).to eq(11)
      end
      
      it 'should decrease the number of tries count if a guess is incorrect' do
        game.play 'z'
        game.reload
        expect(game.current_word_status).to eq(Game::DOT * word.text.length)
        expect(game.tries_left).to eq(10)
      end
      
      it 'should decrease the number of tries count if a guess has more than one letter' do
        game.play 'aw'
        game.reload
        expect(game.current_word_status).to eq(Game::DOT * word.text.length)
        expect(game.tries_left).to eq(10)
      end
      
      it 'should not change the state if the game is still on play' do
        game.play 'e'
        game.reload
        expect(game.status).to eq(Game::STATUS[:BUSY])
      end
      
      describe 'Decision' do
        let(:word){
          Word.create! text: 'a'
        }

        let(:game){
          Game.create! word: word, status: Game::STATUS[:BUSY], tries_left: 1
        }
        
        describe 'Success' do
          it 'should mark a game success when all the letters are revealed before the number of tries run out' do
            game.play 'a'
            game.reload
            expect(game.current_word_status).to eq('a')
            expect(game.status).to eq(Game::STATUS[:SUCCESS])
          end
        end

        describe 'Fail' do
          it 'should mark a game fail when not all the letters are revealed before the number of tries ran out' do
            game.play 'z'
            game.reload
            expect(game.current_word_status).to eq(Game::DOT)
            expect(game.status).to eq(Game::STATUS[:FAIL])
          end
        end
        
        it 'should not let you play the game if the status is not busy' do
          game.status = Game::STATUS[:FAIL]
          game.save!
          game.play 'a'
          expect(game.status).to eq(Game::STATUS[:FAIL])
          expect(game.tries_left).to eq(1)
        end
      end
    
    end
    
  end

end
