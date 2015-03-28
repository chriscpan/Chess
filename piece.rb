require_relative 'board.rb'

class Piece

  attr_accessor :pos
  attr_reader :symbol, :color

  def initialize(color, pos, symbol, board)
    @color, @pos, @symbol, @board = color, pos, symbol, board
  end

  def moves
    possible_moves = []
    if self.class == Pawn
      move_dirs.each do |move_dir|
        possible_moves << [pos.first + move_dir.first, pos.last + move_dir.last]
      end
    else
      possible_moves = slide_step_moves
    end
    possible_moves #.reject do |move|
    #   @board.duplicate.move!(@pos, move).in_check?
    # end
  end

  def slide_step_moves
    possible_pos = []
    move_dirs.each do |move_dir|
      new_pos = [@pos.first + move_dir.first, @pos.last + move_dir.last]
      possible_pos += add_moves(new_pos, move_dir)
    end
    possible_pos
  end

  def add_moves(new_pos, move_dir)
    outcome = check_next_move(new_pos)
    if outcome == :next
      []
    elsif outcome == :attacked_opponent
      [new_pos]
    else
      if self.class.superclass == Stepping
        [new_pos]
      else
        next_pos = [new_pos.first + move_dir.first, new_pos.last + move_dir.last]
        [new_pos] + add_moves(next_pos, move_dir)
      end
    end
  end

  def check_next_move(new_pos)
    if !new_pos.first.between?(0, 7) || !new_pos.last.between?(0, 7)
      :next
    elsif @board[new_pos].nil?
      :empty_square
    elsif @board[new_pos].color == @color
      :next
    else
      :attacked_opponent
    end
  end

  def move_into_check?(end_pos)
    dup_board = board.duplicate
    dup_board.move(@pos, end_pos)
    dup_board.in_check?
  end
end
