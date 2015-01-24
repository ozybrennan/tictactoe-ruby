require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos

  PLAYER_ONE_MOVER_MARK = :x
  PLAYER_TWO_MOVER_MARK = :o

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  # This method generates an array of all moves that can be made after
  # the current move.

  def children
    children = []
    (0..2).each do |row|
      (0..2).each do |column|
        if @board[[row, column]].nil?
          new_board = @board.dup
          new_board[[row, column]] = @next_mover_mark
          if @next_mover_mark == PLAYER_ONE_MOVER_MARK
            mover_mark = PLAYER_TWO_MOVER_MARK
          else
            mover_mark = PLAYER_ONE_MOVER_MARK
          end
          children << TicTacToeNode.new(new_board, mover_mark, [row, column])
        end
      end
    end
    children
  end

  def losing_node?(evaluator)
    if @board.over?
      if @board.winner == nil || @board.winner == evaluator
        false
      else
        true
      end
    else
      if @next_mover_mark == evaluator && children.all? { |child| child.losing_node?(evaluator) }
        true
      elsif @next_mover_mark != evaluator && children.any? { |child| child.losing_node?(evaluator) }
        true
      else
        false
      end
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      if @board.winner == evaluator
        true
      else
        false
      end
    else
      if @next_mover_mark == evaluator && children.any? { |child| child.winning_node?(evaluator) }
        true
      elsif @next_mover_mark != evaluator && children.all? { |child| child.winning_node?(evaluator) }
        true
      else
        false
      end
    end
  end

  def how_far_losing(evaluator)
    return n = 0 if @board.over?
    least_n = 10
    children.each do |child|
      n = child.how_far_losing(evaluator)
      if n < least_n
        least_n = n
      end
    end
    n += 1
  end

  def how_far_winning(evaluator)
    return n = 0 if @board.over?
    least_n = 10
    children.each do |child|
      n = child.how_far_winning(evaluator)
      if n < least_n
        least_n = n
      end
    end
    n += 1
  end

end
