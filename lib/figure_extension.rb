module FigureExtension
  def king_in_check?(color, field, board)
    if color == 'white' && field == board.black_king['coords']
      # puts 'black KING IN CHECK from figure ext!!'
      board.black_king['in_check'] = true
    elsif field == board.white_king['coords']
      # puts 'white KING IN CHECK from figure ext!!'
      board.white_king['in_check'] = true
    end
  end
end
