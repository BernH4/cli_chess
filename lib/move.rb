module Move
  def common_no_selfkill?(figure, target_coords)
    figure.figurecolor != board.board_hash.figure(target_coords).figurecolor
  end

  def common_no_jumpover?(figure, target_coords)
  end

  def common_defend_king?(figure, target_coords)
  end

end
