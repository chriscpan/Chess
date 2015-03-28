require_relative 'stepping.rb'

class Knight < Stepping

  MOVE_DIRECTIONS ||= [ [-1,2], [1,2], [2,1], [2, -1], [1,-2],[-1,-2],
                    [-2,-1], [-2,1] ]

  def move_dirs
    MOVE_DIRECTIONS
  end
end
