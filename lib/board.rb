class Board
  attr_accessor :board_hash, :white_king, :black_king

  def initialize
    @columns = ('a'..'h').to_a
    @board_hash = generate_board
    @white_king = { 'coords' => 'e1', 'in_check' => false }
    # @white_king = { 'coords' => 'd5', 'in_check' => false }
    @black_king = { 'coords' => 'd5', 'in_check' => false }
    # @black_king = { 'coords' => 'e8', 'in_check' => false }
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

  def reposition(figure, target_coords)
    figure_coords = figure.curr_coords.x + figure.curr_coords.y
    update_king_pos(figure.color, target_coords) if figure.instance_of?(King)
    figure.curr_coords.reassign(target_coords)
    @board_hash[target_coords] = figure
    @board_hash[figure_coords] = nil
    figure.first_move_done = true if figure.instance_of?(Pawn)
  end

  private

  def generate_board
    board = {}
    fig_pos = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    # fig_pos = [Rook, Knight, Bishop, Queen, Pawn, Bishop, Knight, Rook] # debug
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
        # board['b5'] = Knight.new('b5', "white") #debug test
        # board['e4'] = King.new('e4', "black") #debug test
        # board['d5'] = King.new('d5', 'black') # debug test
        # board['a3'] = Queen.new('a3', 'white') # debug test
        # board['h3'] = Queen.new('h3', 'white') # debug test
      end
    end
    board
  end

  def print_field(coords, marked: false)
    empty_field_fill = marked ? '·' : ' '
    figure = @board_hash[coords]&.symbol || empty_field_fill
    # Figure std color is defined in the ascci character
    std_color = "\e[30;"
    red_color = "\e[31;"
    col_bg_white = '103m'
    col_bg_black = '43m'
    figure_color = marked ? red_color : std_color
    bg_color = bg_white?(coords) ? col_bg_white : col_bg_black

    print figure_color + bg_color + " #{figure} " + "\e[0m"
  end

  # If row and column are both even or both not even the background color is white (or light yellow in my case)
  def bg_white?(coords)
    col, row = coords.split('')
    @columns.index(col).even? == row.to_i.even?
  end

  def update_king_pos(color, target_coords)
    color == 'white' ? @white_king['coords'] = target_coords : @black_king['coords'] = target_coords
  end
end
