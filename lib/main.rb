require_relative 'board.rb'
require_relative 'game.rb'
require_relative 'figures.rb'
require_relative 'user_interaction.rb'
require 'pry-byebug'
# require 'pry'
require 'ap'

board = Board.new
game = Game.new(board)
game.start
