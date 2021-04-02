require_relative 'board.rb'
require_relative 'figures.rb'
require_relative 'user_interaction.rb'
require 'pry'
require 'ap'

board = Board.new
game = Game.new.start(board)
until false
  game.play("white")
  game.play("black")
end
  

