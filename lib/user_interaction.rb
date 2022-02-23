module User_Interaction
  def user_ask_figure
    puts "What figure do you want to move? (e.g: a2)"
    gets.chomp
  end
  def user_ask_target#(player)
    puts "Target?"
    gets.chomp
  end
end

