# frozen_string_literal: true

require_relative 'display'
require_relative 'player'

# connect four game logic
class ConnectFour < Display
  attr_reader :restart, :player1, :player2

  def initialize(player1 = 'Player1', player2 = 'Player2')
    system "clear"
    @player1 = Player.new(name(player1), "●")
    @player2 = Player.new(name(player2), '○')
    @board = []
    @x = 0
    @y = 0
    @restart = false
  end

  def name(default)
    chosen = name_input(default)
    chosen.empty? ? default : chosen
  end

  def create_board
    puts 'Choose board width that is between 5 and 20 or press enter to continue'
    @x = board_input(7)
    puts 'Choose board heighth that is between 5 and 20 or press enter to continue'
    @y = board_input(6)
    @y.times do
      row = []
      @x.times do
        row.push('_')
      end
      @board.push(row)
    end
  end

  def board_input(default_size)
    loop do
      size = obtain_input
      return default_size if size == ''
      return size.to_i if size.to_i.between?(5, 20)
    end
  end

  def play_game
    winner = nil
    system "clear"
    loop do
      winner = @player1
      puts show_board(@board)
      puts "It's #{@player1.name} turn"
      input = game_input
      make_turn(input, @player1)
      break if victory?(@player1)
      winner = @player2
      puts show_board(@board)
      puts "It's #{@player2.name} turn"
      input = game_input
      make_turn(input, @player2)
      break if victory?(@player2)
    end
    victory(winner)
  end

  def make_turn(input, player)
    current_height = @y-1
    input -= 1
    if @board[current_height][input] == '_'
      while @board[current_height-1][input] == '_' && current_height != 0 do
        animate(current_height, input, player)
        current_height -= 1
      end
      @board[current_height][input] = player.symbol
      last_coordinates(player, input, current_height)
      system "clear"
      @board
    else
      puts 'Column already full! Choose another one'
      input = game_input
      make_turn(input, player)
    end
  end

  def animate(current_height, input, player)
    @board[current_height][input] = player.symbol
        system "clear"
        puts show_board(@board)
        puts "It's #{player.name} turn"
        sleep(0.05)
        @board[current_height][input] = '_'
  end

  def last_coordinates(player, input, current_height)
    player.last_x = input
    player.last_y = current_height
  end

  def victory?(player)
    return true if check_vertical(player.last_x, player.last_y, player.symbol)
    return true if check_horizontal(player.last_x, player.last_y, player.symbol)
    return true if check_d_diagonal_l_r(player.last_x, player.last_y, player.symbol)
    return true if check_u_diagonal_l_r(player.last_x, player.last_y, player.symbol)
    return true if @board.flatten.index('_').nil?

    false
  end

  def check_vertical(x, y, symbol)
    return true if y >= 3 && [@board[y - 1][x], @board[y - 2][x], @board[y - 3][x]].all?(symbol)

    false
  end

  def check_horizontal(x, y, symbol)
    return true if (x + 3 < @x) && [@board[y][x + 1], @board[y][x + 2], @board[y][x + 3]].all?(symbol)
    return true if (x - 3 >= 0) && [@board[y][x - 1], @board[y][x - 2], @board[y][x - 3]].all?(symbol)

    false
  end

  def check_d_diagonal_l_r(x, y, symbol)
    return true if (x - 3 >= 0) && y >= 3 && [@board[y - 1][x - 1], @board[y - 2][x - 2], @board[y - 3][x - 3]].all?(symbol)
    return true if (x + 3 < @x) && y >= 3 &&[@board[y - 1][x + 1], @board[y - 2][x + 2], @board[y - 3][x + 3]].all?(symbol) 

    false
  end

  def check_u_diagonal_l_r(x, y, symbol)
    return true if y + 3 < @y && (x - 3 >= 0) && [@board[y + 1][x - 1], @board[y + 2][x - 2], @board[y + 3][x - 3]].all?(symbol)
    return true if (x + 3 < @x) && y + 3 < @y && [@board[y + 1][x + 1], @board[y + 2][x + 2], @board[y + 3][x + 3]].all?(symbol)

    false
  end

  def victory(player)
    puts show_board(@board)
    puts @board.flatten.index('_').nil? ? tie_message : congratulations_message(player.name)
    @restart = restart_input
  end

  private

  def name_input(default)
    puts rename_message(default)
    gets.chomp
  end

  def obtain_input
    gets.chomp
  end

  def game_input
    loop do
      input = gets.chomp.to_i
      return input if input.between?(1, @x)
    end
  end

  def restart_input
    loop do 
      input = gets.chop
      return false if input.downcase == 'n' || input.downcase == 'no'
      return true if input.downcase == 'y' || input.downcase == 'yes'
    end
  end
end
