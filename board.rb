require 'byebug'
require_relative 'rook.rb'
require_relative 'knight.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'king.rb'
require_relative 'pawn.rb'
require_relative 'error.rb'
require "colorize"
class Board

  attr_accessor :grid

  def initialize(grid = false)
    if grid
      @grid = make_default_board
    else
      @grid = []
    end
    @lost_black_pieces = []
    @lost_white_pieces = []
  end

  def []=(pos, val)  # grid[x, y] = "knight" => grid[y][x] = knight
    x, y = pos
    @grid[y][x] = val
  end

  def [](pos)      # grid[x, y] => "knight"
    x, y = pos
    @grid[y][x]
  end

  def duplicate
    dup_board = Board.new(false)
    @grid.each do |row|
      dup_row = []
      row.each do |piece|
        #debugger
        if piece.nil?
          dup_row << nil
        else
          dup_row << piece.class.new(piece.color, piece.pos, piece.symbol, dup_board)
        end
      end
      dup_board.grid << dup_row
    end
    dup_board
  end

  def move!(start, end_pos)
    self[start].pos = end_pos
    self[start], self[end_pos] = nil, self[start]
    self
  end

  def in_check?(color)
    opponent_pieces = []
    flatten_grid = @grid.flatten
    color == "B" ? king = "♚" : king = "♔"
    flatten_grid.compact.each do |piece|
      if piece.symbol == king
        king = piece
      elsif piece.color != color
        opponent_pieces << piece
      end
    end
    opponent_moves = []
    opponent_pieces.each do |piece|
      opponent_moves << piece.moves
    end
    opponent_moves.flatten!(1)
    opponent_moves.include?(king.pos)
  end

  def checkmate?(color)
    king = @grid.flatten.find {|piece| piece.class == King && piece.color == color}
    no_escape = true
    king.moves.each do |move|
      moved_board = duplicate.move!(king.pos, move)
      if !moved_board.in_check?(color)
        no_escape = false
      end
    end
    no_escape && in_check?(color) && !block_checkmate(color)
  end

  def block_checkmate(color)
    pos_moves = []
    @grid.flatten.compact.each do |piece|
      if piece.color == color
        pos_moves << [piece.pos, piece.moves]
      end
    end

    pos_moves.each do |position_move|
      pos = position_move[0]
      moves = position_move[1]
      moves.each do |move|
        if !self.duplicate.move!(pos, move).in_check?(color)
          return true
        end
      end
    end
    false
  end

  def start_move_nil?(start_move)
    if self[start_move].nil?
      raise MoveError.new("You cannot select a blank space as your first move")
    end
  end

  def make_default_board #color, pos, symbol
    white_row = [Rook.new('W', [0, 0], "♖", self), Knight.new('W', [1, 0], "♘", self),
                 Bishop.new('W', [2, 0], "♗", self), Queen.new('W', [3, 0], "♕" , self),
                 King.new('W', [4, 0],"♔", self), Bishop.new('W', [5, 0], "♗", self),
                 Knight.new('W', [6, 0], "♘", self), Rook.new('W', [7, 0], "♖", self)]

    white_pawns = []
    8.times do |x_pos|
      white_pawns << Pawn.new('W', [x_pos, 1], "♙", self)
    end

    blank_rows = Array.new(4){Array.new(8)}

    black_pawns = []
    8.times do |x_pos|
      black_pawns << Pawn.new('B', [x_pos, 6], "♟", self)
    end

    black_row = [Rook.new('B', [0, 7], "♜", self), Knight.new('B', [1, 7], "♞", self),
                 Bishop.new('B', [2, 7], "♝", self), Queen.new('B', [3, 7], "♛", self),
                 King.new('B', [4, 7], "♚", self), Bishop.new('B', [5, 7], "♝", self),
                 Knight.new('B', [6, 7], "♞", self), Rook.new('B', [7, 7], "♜", self)]

    [white_row] + [white_pawns] + blank_rows + [black_pawns] + [black_row]
  end

  def display
    print_board = duplicate.grid.reverse
    print_board.each do |row|

      row.map! do |square|

        if square.nil?
          square = ' '
        else
          square = square.symbol
        end
      end
      puts row.join('  ')
    end
    nil
  end
end

#
# def color_background(string,row, column)
#   case (row+column)%2
#   when 0
#     string.colorize(:color => :black, :background => :light_white)
#   when 1
#     string.colorize(:color => :black, :background => :white)
#   end
# end
