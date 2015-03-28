require_relative 'piece.rb'
require 'byebug'

class Pawn < Piece

  attr_accessor :moved

  def initialize(color, pos, symbol, board)
    super(color, pos, symbol, board)
    @moved = false
  end

  def move_dirs
    moves = []
    if @color == 'W'
      if @board[[pos.first, pos.last + 1]].nil?
        moves << [0, 1]
        if @board[[pos.first, pos.last + 2]].nil? && !@moved
          moves << [0, 2]
        end
      end
    else
      if @board[[pos.first, pos.last - 1]].nil?
        moves << [0, -1]
        if @board[[pos.first, pos.last - 2]].nil? && !@moved
          moves << [0, -2]
        end
      end
    end
    moves + attacking_moves
  end

  def attacking_moves #does not check if inside bounds
    moves = []
    if @color == 'W'
      if !@board[[pos.first + 1, pos.last + 1]].nil? &&
         @board[[pos.first + 1, pos.last + 1]].color == 'B'
        moves << [1, 1]
      end
      if !@board[[pos.first - 1, pos.last + 1]].nil? &&
         @board[[pos.first - 1, pos.last + 1]].color == 'B'
        moves << [-1, 1]
      end
    else
      if !@board[[pos.first + 1, pos.last - 1]].nil? &&
         @board[[pos.first + 1, pos.last - 1]].color == 'W'
        moves << [1, -1]
      end
      if !@board[[pos.first - 1, pos.last - 1]].nil? &&
         @board[[pos.first - 1, pos.last - 1]].nil? == 'W'
        moves << [-1, -1]
      end
    end
    moves
  end
end
