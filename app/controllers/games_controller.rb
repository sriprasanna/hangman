class GamesController < ApplicationController

  def index
    @games = Game.all
    render json: @games
  end

  def show
    @game = Game.find(params[:id])
    render json: @game
  end

  def create
    @game = Game.create! word: Word.random, status: Game::STATUS[:BUSY]
    render json: @game, status: :created, location: @game
  end
  
  def update
    @game = Game.find(params[:id])
    @game.play params[:char]
    render json: @game
  end

end
