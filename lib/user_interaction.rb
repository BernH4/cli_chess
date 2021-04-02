module User_Interaction
  def user_ask_figure(player)
    puts "Its your turn #{player}!"
    puts "What figure do you want to move? (e.g: a3)"
    gets.chomp
  end
  def user_ask_target(player)
    puts "Target?"
    gets.chomp
  end
end

