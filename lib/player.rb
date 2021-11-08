# frozen_string_literal: true

# player object
class Player
  attr_reader :name, :symbol
  attr_accessor :last_x, :last_y

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @last_x = nil
    @last_y = nil
  end
end
