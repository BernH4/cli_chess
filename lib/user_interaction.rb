module User_Interaction
  def user_ask_figure
    puts "What figure do you want to move? (e.g: a3)"
    gets.chomp
  end
  def user_ask_target#(player)
    puts "Target?"
    gets.chomp
  end


  ##Error Messages
  #def user_error_enemy_figure
  #  puts "
  #end
end

