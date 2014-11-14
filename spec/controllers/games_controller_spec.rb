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
      expect(assigns(:game)).to be_a(Game)
      expect(assigns(:game)).to be_persisted
      expect(assigns(:game).word).to eq(word)
      expect(assigns(:game).status).to eq('busy')
      expect(Word).to have_received(:random)
    end

    it "redirects to the created game" do
      post :create
      game_created = assigns(:game)
      expect(response.headers['Location']).to eq("http://test.host/games/#{game_created.id}")
    end
  end

end
