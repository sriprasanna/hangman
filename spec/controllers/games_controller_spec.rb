require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  
  def random_word
    (0...10).map { ('a'..'z').to_a[rand(26)] }.join
  end
  
  let(:word){
    Word.create! text: random_word
  }
  
  let(:game){
    Game.create! word: word, status: 'busy'
  }

  describe "GET index" do
    it "assigns all games as @games" do
      game_persisted = game
      get :index, {}
      expect(assigns(:games).to_a).to eq([game_persisted])
    end
  end

  describe "GET show" do
    it "assigns the requested game as @game" do
      get :show, {:id => game.to_param}
      expect(assigns(:game)).to eq(game)
      expect(response.body).to eq(game.to_json)
    end
  end
  
  describe "POST create" do
    before :each do
      Word.stub(:random).and_return(word)
    end
    
    it "creates a new Game" do
      expect {
        post :create
      }.to change(Game, :count).by(1)
    end

    it "assigns a newly created game and randomly chosen word" do
      post :create
      game_created = assigns(:game)
      expect(game_created).to be_a(Game)
      expect(game_created).to be_persisted
      expect(game_created.word).to eq(word)
      expect(game_created.status).to eq('busy')
      expect(response.body).to eq(game_created.to_json)
      expect(Word).to have_received(:random)
    end

    it "redirects to the created game" do
      post :create
      game_created = assigns(:game)
      expect(response.headers['Location']).to eq("http://test.host/games/#{game_created.id}")
    end
  end
  
  describe "PUT update" do
    it "should play the game with the passed character" do
      char = 'a'
      Game.stub(:find).with(game.to_param).and_return(game)
      game.stub(:play).with(char).and_return(char)
      put :update, {:id => game.to_param, :char => char}
      expect(game).to have_received(:play).with(char)
      expect(response.body).to eq(game.to_json)
    end
  end

end
