require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    node.children.each do |child|
      if child.winning_node?(mark)
        return child.prev_move_pos
      end
    end
      node.children.each do |child|
        unless child.losing_node?(mark)
          return child.prev_move_pos
        end
     end
    if playable_nodes.nil?
      raise "There are no non-losing nodes. You suck at programming."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
