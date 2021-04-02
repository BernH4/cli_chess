class Rook
  attr_reader :symbol
  def initialize(x, y, color)
    @curr_cords = [x, y]
    @symbol = color == 'white' ? "♜" : "♖"
  end
end

class Knight
  attr_reader :symbol
  def initialize(x, y, color)
    @curr_cords = [x, y]
    @symbol = color == 'white' ? "♞" : "♘"
  end
end

class Bishop
  attr_reader :symbol
  def initialize(x, y, color)
    @curr_cords = [x, y]
    @symbol = color == 'white' ? "♝" : "♗"
  end
end

class Queen
  attr_reader :symbol
  def initialize(x, y, color)
    @curr_cords = [x, y]
    @symbol = color == 'white' ? "♛" : "♕"
  end
end

class King
  attr_reader :symbol
  def initialize(x, y, color)
    @curr_cords = [x, y]
    @symbol = color == 'white' ? "♚" : "♔"
  end
end

class Pawn
  attr_reader :symbol
  def initialize(x, y, color)
    @curr_cords = [x, y]
    @symbol = color == 'white' ? "♙" : "♟︎"
  end
end
