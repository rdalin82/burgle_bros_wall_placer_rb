require './lib/board_graph'
require './lib/wall_edge'


require 'sinatra'
require 'json'

get '/' do
  results = {}
  3.times do |x|
    floor = "#{x+1}"
    app = App.new('./config/board.txt')
    app.run
    results.merge!(floor => app.placed_walls.map(&:to_s).join('; ') )
  end
  @results = results
  erb :index
end

get '/walls' do
  results = {}
  3.times do |x|
    floor = "#{x+1}"
    app = App.new('./config/board.txt')
    app.run
    results.merge!(floor => app.placed_walls )
  end
  @results = results
  content_type :json
  { data: @results }.to_json
end



class App
  attr_accessor :board, :placed_walls, :walls
  def initialize(filename)
    @walls = []
    begin
      file = File.open(filename)
    rescue Exception => e
      puts "OOPS - [e.message]"
    end
    v = file.readline().chomp.to_i || 0
    e = file.readline()
    @board = BoardGraph.new(v)

    if file
      until file.eof?
        line = file.readline.chomp
        args = line.split(" ")
        @walls << WallEdge.new(args[0].to_i, args[1].to_i)
        @board.add_edge(WallEdge.new(args[0].to_i, args[1].to_i))
      end
    else
      puts "You don screwed up"
    end
  end

  def run
    board_dup = @board.dup
    walls = @walls.dup.shuffle
    setup(board_dup, walls)
    # ap @placed_walls.map(&:to_s)
    # ap "Duplicates????"
    # ap @placed_walls.count == @placed_walls.uniq
  end

  def setup(board, walls, placed_walls=[])
    if placed_walls.count == 8  && board.valid?
      @placed_walls = placed_walls
      @board = board
      return true
    end
    until walls.empty?
      wall = walls.pop
      board.place_wall(wall)
      placed_walls << wall
      if board.valid?
        if setup(board, walls, placed_walls)
          return true
        end
      else
        board.add_edge(wall)
        placed_walls.pop
      end
    end
    return false
  end

end

# 3.times do |x|
#   app = App.new(ARGV[0])
#   ap "Floor #{x+1}: "
#   app.run
# end
