require_relative 'sliding.rb'

class Queen < Sliding

  def move_dirs
    ORTHOGONAL + DIAGONAL
  end

end
