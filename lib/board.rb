class Board
  def initialize
    @board = generate_board
  end

  private

  def generate_board
    alphaarr = %w[a b c d e f g h]
    board = Hash.new { |hash, key| hash[key] = {} }
    fig_pos_first_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    8.downto(1) do |row|
      row = row.to_s
      ('a'..'h').to_a.each do |col|
        case row.to_i
        when 1 
          board[col][row] = fig_pos_first_row[alphaarr.index(col)].new(col, row)
        when 8 
          #swap Queen and King
          fig_pos_first_row[3], fig_pos_first_row[4] =  fig_pos_first_row[4], fig_pos_first_row[3]
          board[col][row] = fig_pos_first_row[alphaarr.index(col)].new(col, row)
        when 7 ,2
          board[col][row] = Pawn.new(col,row)
        else
          board[col][row] = nil
        end
      end
    end
    # binding.pry
    ap board
    board
  end
end
