# frozen_string_literal: true

class Display
  def rename_message(default)
    "#{default} change your name if you wish or press enter to continue"
  end

  def show_board(a)
    x = a[0].length
    y = a.length
    board = ''
    y.times do |i|
      x.times do |j|
        board += "|#{a[y-i-1][j]} "
      end
      board += "|\n"
    end
    counter = 1
    x.times do |i|
      board += i <= 8 ? "|#{counter} " : "|#{counter}"
      counter += 1
    end
    board += "|\n"
  end

  def tie_message
    message = "It's a tie!"
    "\e[32m#{message}\e[0m\nDo you wish to play again? Y/N"
  end

  def congratulations_message(name)
    message = "Congratulations #{name}, you win!"
    "\e[32m#{message}\e[0m\nDo you wish to play again? Y/N"
  end
end

