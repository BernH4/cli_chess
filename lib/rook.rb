class Rook
  include CommonInvalidMoves
  include Display
  def initialize(color, default_coords)
    @color = color
    @curr_coords = default_coords
  end

  def move(board, x, y)
    @wanted_coords = [x,y]
    if valid_move?
      # board.curr_coords = nil
      # @curr_coords = [x, y]
      # board.curr_cords = self
    else
      # display_invalid_move(x, y)
    end
    @wanted_coords = nil
  end

  private

  def valid_move?
    move_straight_line? &&
      common_no_jumpover? &&
      common_no_selfkill? &&
      common_defend_king?
  end
end
