# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFour do
  subject(:game) { described_class.new }
  let(:display) { instance_double(Display) }
  describe '#name' do
    let(:chosen_name) { 'Cookie Monster' }
    before do
      allow(game).to receive(:name_input).and_return(chosen_name)
    end

    it 'returns a new name if input is given' do
      expect(game.name(chosen_name)).to eq(chosen_name)
    end

    subject(:game_empty) { described_class.new }
    let(:default_name) { 'Player1' }
    before do
      allow(game_empty).to receive(:name_input).and_return('')
    end
    it 'returns a default name if input is not given' do
      expect(game_empty.name(default_name)).to eq(default_name)
    end
  end

  describe '#board input' do
    before do
      allow(game).to receive(:obtain_input).and_return(5)
    end
    it 'returns size if it is between 5 and 20' do
      expect(game.board_input(6)).to eq(5)
    end
    subject(:game_wrong_input) { described_class.new }
    before do
      allow(game_wrong_input).to receive(:obtain_input).and_return('21', '4', '@', '')
    end
    it 'waits until valid input and returns default value after no input was given' do
      expect(game_wrong_input.board_input(7)).to eq(7)
    end
  end

  describe '#make_turn' do
    before do
      allow(game).to receive(:last_coordinates).and_return(0)
      game.instance_variable_set(:@y, 6)
      game.instance_variable_set(:@board, [["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"]])
    end
    it 'places first symbol on bottom' do
      player = instance_double(Player, name: 'Player1', symbol: 'X')
      turn = [["_", "X", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"]]
      expect(game.make_turn(2, player)).to eq(turn)
    end
    subject(:game_second_turn) { described_class.new }
    before do
      allow(game_second_turn).to receive(:last_coordinates).and_return(0)
      game_second_turn.instance_variable_set(:@y, 6)
      game_second_turn.instance_variable_set(:@board, [["_", "X", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"]])
    end
    it 'places second symbol on top of first' do
      turn = [["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"]]
      expect(game_second_turn.make_turn(2, double(Player, name: 'Player2', symbol: 'O'))).to eq(turn)
    end
    subject(:game_full_column) { described_class.new }
    before do
      allow(game_full_column).to receive(:last_coordinates).and_return(0)
      game_full_column.instance_variable_set(:@y, 6)
      game_full_column.instance_variable_set(:@board, [["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"]])
      allow(game_full_column).to receive(:game_input).and_return(3)
    end
    it 'When column is full player is able to choose another column' do
      turn = [["_", "X", "O", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"]]
      expect(game_full_column.make_turn(2, double(Player, name: 'Player2', symbol: 'O'))).to eq(turn)
    end
    subject(:game_repeating) { described_class.new }
    before do
      allow(game_repeating).to receive(:last_coordinates).and_return(0)
      game_repeating.instance_variable_set(:@y, 6)
      game_repeating.instance_variable_set(:@board, [["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"]])
      allow(game_repeating).to receive(:game_input).and_return(2, 2, 2, 2, 4)
    end
    it 'Keeps asking new input while the choosen column is full' do
      turn = [["_", "X", "_", "O", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["_", "O", "_", "_", "_", "_"], ["_", "X", "_", "_", "_", "_"]]
      expect(game_repeating.make_turn(2, double(Player, name: 'Player2', symbol: 'O'))).to eq(turn)
    end
  end

  describe '#check vertical' do
    before do
      game.instance_variable_set(:@y, 7)
      game.instance_variable_set(:@x, 6)
      game.instance_variable_set(:@board, [["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"]])
    end
    it 'Returns true when 4 vertical' do
      expect(game.check_vertical(0, 3, 'X')).to eq(true)
    end
    it 'Returns false when not 4 vertical' do
      expect(game.check_vertical(1, 3, 'X')).to eq(false)
    end
    it 'Guard clause triggers' do
      expect(game.check_vertical(0, 2, 'X')).to eq(false)
    end
  end

  describe '#check horizontal' do
    before do
      game.instance_variable_set(:@y, 7)
      game.instance_variable_set(:@x, 6)
      game.instance_variable_set(:@board, [["O", "O", "O", "O", "_", "0"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"]])
    end
    it 'Returns true when 4 horizontal to right' do
      expect(game.check_horizontal(0, 0, 'O')).to eq(true)
    end
    it 'Returns true when 4 horizontal to left' do
      expect(game.check_horizontal(3, 0, 'O')).to eq(true)
    end
    it 'Returns false when not 4 horizontal' do
      expect(game.check_horizontal(2, 0, 'O')).to eq(false)
    end
    it 'Returns false when not 4 horizontal' do
      expect(game.check_horizontal(1, 0, 'O')).to eq(false)
    end
  end

  describe '#check diagonal down' do
    before do
      game.instance_variable_set(:@y, 7)
      game.instance_variable_set(:@x, 6)
      game.instance_variable_set(:@board, [["O", "X", "_", "_", "_", "X"], ["_", "O", "X", "_", "X", "_"], ["_", "_", "O", "X", "_", "_"], ["_", "_", "X", "O", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["_", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"]])
    end
    it 'Returns true when 4 diagonal left' do
      expect(game.check_d_diagonal_l_r(3, 3, 'O')).to eq(true)
    end
    it 'Returns false when reaches bottom' do
      expect(game.check_d_diagonal_l_r(3, 2, 'X')).to eq(false)
    end
    it 'Returns true when 4 diagonal right' do
      expect(game.check_d_diagonal_l_r(2, 3, 'X')).to eq(true)
    end
  end

  describe '#check diagonal up' do
    before do
      game.instance_variable_set(:@y, 7)
      game.instance_variable_set(:@x, 6)
      game.instance_variable_set(:@board, [["O", "X", "_", "_", "X", "X"], ["_", "O", "X", "_", "X", "_"], ["_", "_", "O", "X", "_", "_"], ["_", "_", "X", "O", "_", "_"], ["_", "X", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"], ["X", "_", "_", "_", "_", "_"]])
    end
    it 'Returns true when 4 diagonal left' do
      expect(game.check_u_diagonal_l_r(0, 0, 'O')).to eq(true)
    end
    it 'Returns false when reaches bottom' do
      expect(game.check_u_diagonal_l_r(5, 3, 'X')).to eq(false)
    end
    it 'Returns true when 4 diagonal right' do
      expect(game.check_u_diagonal_l_r(5, 0, 'X')).to eq(true)
    end
  end
end
