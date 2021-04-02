class Board
  def initialize
    @board = generate_board
  end

  def print_board
    8.downto(1) do |row|
      row = row.to_s
      print " #{row} "
      @board.keys.each do |col|
        print_field(col, row)
      end
      puts
    end
    puts '    a  b  c  d  e  f  g  h'
  end

  private

  def generate_board
    alphaarr = %w[a b c d e f g h]
    board = Hash.new { |hash, key| hash[key] = {} }
    fig_pos = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    8.downto(1) do |row|
      binding.pry
      row = row.to_s
      ('a'..'h').to_a.each do |col|
        board[col][row] =
          case row.to_i
          when 1
            fig_pos[alphaarr.index(col)].new(col, row, 'black')
          when 8
            fig_pos[alphaarr.index(col)].new(col, row, 'white')
          when 7
            Pawn.new(col, row, 'black')
          when 2
            Pawn.new(col, row, 'white')
          end
      end
    end
    ap board
    board
  end

  def print_field(col, row)
    figure = @board[col][row]&.symbol || ' '
    if bg_white?(col, row)
      print "\e[30;103m #{figure} \e[0m"
    else
      print "\e[30;43m #{figure} \e[0m"
    end
  end

  # If row and column are both even or both not even the color is white (or light yellow in my case)
  def bg_white?(col, row)
    ('a'..'h').to_a.index(col).even? == row.to_i.even?
  end
end
