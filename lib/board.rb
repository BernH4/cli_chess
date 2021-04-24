class Board
  attr_accessor :board_hash

  def initialize
    @columns = ('a'..'h').to_a
    @board_hash = generate_board
  end

  def print_board(possible_moves = [])
    8.downto(1) do |row|
      row = row.to_s
      print " #{row} "
      @columns.each do |col|
        coords = col + row
        possible_moves.include?(coords) ? print_field(coords, marked: true) : print_field(coords)
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
        # board['d4'] = King.new('d4', "white") #debug test
        # board['e4'] = King.new('e4', "black") #debug test
        board['d2'] = Queen.new('d2', 'white') # debug test
      end
    end
    board
  end

  # red dot todo for marking possible moves \e[31m·
  def print_field(coords, marked: false)
    empty_field_fill = marked ? "·" : " "
    figure = @board_hash[coords]&.symbol || empty_field_fill
    std_color = "\e[30;"
    red_color = "\e[31;"
    col_bg_white = '103m'
    col_bg_black = '43m'
    figure_color = marked ? red_color : std_color
    bg_color = bg_white?(coords) ? col_bg_white : col_bg_black
    # Figure is defined in the ascci character
    print figure_color + bg_color + " #{figure} " + "\e[0m"

    # if bg_white?(coords)
    #   print "\e[30;103m #{figure} \e[0m"
    # else
    #   print "\e[30;43m #{figure} \e[0m"
    # end
  end

  # If row and column are both even or both not even the color is white (or light yellow in my case)
  def bg_white?(coords)
    col, row = coords.split('')
    @columns.index(col).even? == row.to_i.even?
  end
end
