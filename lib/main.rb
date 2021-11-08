# frozen_string_literal: true

require_relative 'connect_four'

def start(player1 = 'Player1', player2 = 'Player2')
  game = ConnectFour.new(player1, player2)
  game.create_board
  game.play_game
  start(game.player1.name, game.player2.name) if game.restart
end

start
