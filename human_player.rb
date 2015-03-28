require_relative 'player.rb'

class HumanPlayer < Player

  # def initialize(player1)
  #   @player1 = 'W'
  # end

  def get_move
    move = gets.chomp
    if move == 'save'
      'save'
    else
      move.split(',').map(&:strip)
    end
  end
end
