require_relative 'sliding.rb'

class Bishop < Sliding

  def move_dirs
    DIAGONAL
  end
  
end
