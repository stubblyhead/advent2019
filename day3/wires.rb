require 'matrix'

input = File.readlines('./input', :chomp=>true)

class Board

  def initialize
    @grid = Matrix[[[false, false, true]]] #[0,0] matrix, each cell is wire 0, wire 1, and origin
    @row, @col = 0, 0
  end

  def move(dir, wire)
