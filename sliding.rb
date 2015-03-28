require_relative 'piece.rb'

class Sliding < Piece
  ORTHOGONAL ||= [ [1,0], [0,1], [-1, 0], [0,-1] ]
  DIAGONAL ||= [ [1,-1] , [1,1], [-1, 1], [-1,-1] ]
end
