class Board
  attr_accessor :board_hash

  def initialize
    @columns = ('a'..'h').to_a
    @board_hash = generate_board
  end

  def print_board
    8.downto(1) do |row|
      row = row.to_s
      print " #{row} "
      @columns.each do |col|
        print_field(col + row)
      end
      puts
    end
    puts '    a  b  c  d  e  f  g  h'
  end

  # get figure by coordinates (input as string "a2" or instance of class Coordinates)
  def figure(coords)
    coords = coords.x + coords.y if coords.instance_of?(Coordinates)
    return nil unless coords =~ /[a-h][1-8]/

    @board_hash[coords]
  end

  def reposition(figure, figure_coords, target_coords)
    figure.curr_coords.reassign(target_coords)
    @board_hash[target_coords] = figure
    @board_hash[figure_coords] = nil
  end

  private

  def generate_board
    board = {}
    fig_pos = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    8.downto(1) do |row|
      row = row.to_s
      ('a'..'h').to_a.each do |col|
        coords = col + row
        board[coords] =
          case row.to_i
          when 1
            fig_pos[@columns.index(col)].new(coords, 'white')
          when 8
            fig_pos[@columns.index(col)].new(coords, 'black')
          when 7
            Pawn.new(coords, 'black')
          when 2
            Pawn.new(coords, 'white')
          end
        board['d4'] = King.new('d4', "white") #debug test
        board['e4'] = King.new('e4', "black") #debug test
        board['c4'] = King.new('c4', "black") #debug test
      end
    end
    board
  end

  def print_field(coords)
    figure = @board_hash[coords]&.symbol || ' '
    if bg_white?(coords)
      print "\e[30;103m #{figure} \e[0m"
    else
      print "\e[30;43m #{figure} \e[0m"
    end
  end

  # If row and column are both even or both not even the color is white (or light yellow in my case)
  def bg_white?(coords)
    col, row = coords.split('')
    @columns.index(col).even? == row.to_i.even?
  end
end
