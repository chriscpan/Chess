require_relative 'stepping.rb'

class King < Stepping

  MOVE_DIRECTIONS ||= [ [1,-1], [1,1], [-1, 1], [-1,-1], [1,0],
                    [0,1], [-1, 0], [0,-1] ]

  def move_dirs
    MOVE_DIRECTIONS
  end
end
