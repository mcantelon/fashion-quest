module Handles_Scoring

  include Handles_YAML_Files

  attr_accessor :scoring, :max_score, :score, :scored

  def initialize_scoring(game_path)

    @score     = 0
    @max_score = 0
    @scored    = {}

    # load scoring specification
    @scoring = load_yaml_file("#{game_path}scoring.yaml")

    # compute maximum score
    scoring.each do |id, score|
      @max_score = @max_score + score['points'].to_i
    end

  end

  def set_score(id)

    if !scored[id]

      @score = @score + @scoring[id]['points']

    end

  end

end
