module FigureExtension

  # Will add enemys or empty fields on path to possible_moves
  # It will stop walking current path if theres a figure in the way with throw 
  # (catched in coordinates.rb)
  def add_if_poss_move(board, field, must_kill: false, must_be_empty: false, use_throw: true)
    figure = board.figure(field)

    if figure
      if figure.color != @color && !must_be_empty
        king_in_check?(@color, field, board)
        @possible_moves << field
      end
      throw :breakinnerloop if use_throw
    else #empty field
      @possible_moves << field unless must_kill
    end
  end

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
