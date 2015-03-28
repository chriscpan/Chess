require_relative 'board.rb'
require_relative 'human_player.rb'
require 'byebug'
require 'yaml'

class Game

  MOVES ||= { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5,
            "g" => 6, "h" => 7, "1" => 0, "2" => 1, "3" => 2, "4" => 3,
            "5" => 4, "6" => 5, "7" => 6, "8" => 7}

  def initialize(player1, player2)        #player1 => white, #player2 => black
    @player1, @player2 = player1, player2
    if player1.color.nil?
      player1.color, player2.color = 'W', 'B'
    end
    @board = Board.new(true)
    @board.display
    play
  end

  def play
    player = @player1

    while !@board.checkmate?(player.color)
      begin
        puts "#{player} select start move, end move"
        player_move = player.get_move
        if player_move == 'save'
          save
          exit
        end
        valid_input?(player_move)
        start_move, end_move = transform_input(player_move)
        @board.start_move_nil?(start_move)
        debugger
        if !@board[start_move].moves.include?(end_move)
          raise MoveError.new("Your #{@board[start_move].symbol}  cannot move to that square.")
        elsif @board.duplicate.move!(start_move, end_move).in_check?(player.color)
            raise MoveError.new("You cannot move into check")
        elsif @board.in_check?(player.color) &&
              @board.duplicate.move!(start_move, end_move).in_check?(player.color)
            raise MoveError.new("You are still in check")
        end
      rescue MoveError => e
        puts e
        retry
      end
      @board.move!(start_move, end_move)
      @board.display
      player == @player1 ? player = @player2 : player = @player1
    end
  end

  def transform_input(player_move)
    start_move = [MOVES[player_move[0][0]], MOVES[player_move[0][1]]]
    end_move = [MOVES[player_move[1][0]], MOVES[player_move[1][1]]]
    [start_move, end_move]
  end

  def valid_input?(player_move)
    start_x = player_move[0][0]
    start_y = player_move[0][1].to_i
    end_x = player_move[1][0]
    end_y = player_move[1][1].to_i
    if !('a'..'h').include?(start_x) || !('a'..'h').include?(end_x) ||
       !start_y.between?(1, 8) || !end_y.between?(1, 8)
      raise MoveError.new("Position out of bounds, please retry")
    end
    true
  end


  def save
    File.open('chess.yml', 'w') do |f|
      f.puts self.to_yaml
    end
  end

  def load
    YAML.load_file('chess.yml').play
  end
end
