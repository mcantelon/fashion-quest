class Command

  include Handles_YAML_Files

  attr_accessor :syntax, :triggers, :logic

  def initialize(params)

    @game         = params[:game]
    @image_stack  = params[:image_stack]
    @output_stack = params[:output_stack]

  end

  def try(lexemes)

    error = ''

    if @syntax

      @syntax.each do |syntax|

        syntax_lexemes = syntax.split(' ')

        if syntax_lexemes.length == lexemes.length

          # test submitted lexemes against this syntax
          valid = try_syntax_keywords(syntax_lexemes, lexemes)

          # arg, prop, and character are all variables meant to be utilized by command logic
          #arg  = {}
          #prop = character = ''

          # if keywords match, test references
          if valid

            result = determine_command_arguments(syntax_lexemes, lexemes)

            if result['error']
              valid = false
              error = result['error']
            end

            arg       = result['arg']
            prop      = result['prop']
            character = result['character']
            door      = result['door']
            any       = result['any']

            if character
              noun = character.noun
              noun_cap = character.noun_cap
            end

          end

          if valid

            # create these variables to make it less confusing for command writers
            game       = @game
            player     = @game.player
            characters = @game.characters
            locations  = @game.locations
            doors      = @game.doors

            if @game.player
              location   = @game.player.location
            else
              error('No player location is set.')
            end

            props      = @game.props

            return instance_eval(@logic)
          end

        end
      end
    end

    if error != ''
      error

    else

     false
    end

    #return false
  end

  def try_syntax_keywords(syntax_lexemes, submitted_lexemes)

    valid = true
    lexeme_to_test = 0

    syntax_lexemes.each do |lexeme|

      # if lexeme doesn't reference a prop or character, test as a keyword
      if lexeme[0] != ?< and lexeme != submitted_lexemes[lexeme_to_test]
        valid = false
      end

      lexeme_to_test += 1

    end

    valid

  end

  def determine_command_arguments(syntax_lexemes, input_lexemes)

    lexeme_to_test = 0

    lexemes = input_lexemes

    # arg, prop, and character are all variables meant to be utilized by command logic
    arg   = {}
    door = prop = character = any = nil
    error = nil

    syntax_lexemes.each do |lexeme|

      # lexeme references a door or prop or character
      if lexeme[0] == ?<

        # trim "<" and ">" from reference to determine reference type
        reference_type, reference_name = lexeme[1..-2].split(':')

        case reference_type

          when 'any':

            potential_component = lexemes[lexeme_to_test]

            if @game[potential_component]
              any = @game[potential_component]
            end

          # handle named or unnamed door references
          when 'door':

            potential_door = lexemes[lexeme_to_test]

            # need to test that door exists and near player
            if not @game.doors[potential_door]
              error = @game.prop_404(potential_door)
            elsif not @game.doors[potential_door].locations.include?(@game.locations[@game.player.location].name)
              error = @game.prop_404(potential_door)
            end

            if reference_name
              arg[reference_name] = @game.doors[potential_door]
            else
              door = @game.doors[potential_door]
            end

          # handle named or unnamed prop references
          when 'prop':

            potential_prop = lexemes[lexeme_to_test]

            # need to test that prop exists and near player
            if not @game.props[potential_prop]
              error = @game.prop_404(potential_prop)
            elsif @game.props[potential_prop].location != @game.locations[@game.player.location].name and
              @game.props[potential_prop].location != 'player'

              error = @game.prop_404(potential_prop)
            end

            if reference_name
              arg[reference_name] = @game.props[potential_prop]
            else
              prop = @game.props[potential_prop]
            end

          # handle named or unnamed character references
          when 'character':

            potential_character = lexemes[lexeme_to_test]

            # need to not only test that character exists, but that it's here
            if not @game.characters[potential_character]
              error = @game.prop_404(potential_character)
            elsif @game.characters[potential_character].location != @game.locations[@game.player.location].name and
              @game.characters[potential_character].location != 'player'
              error = @game.prop_404(potential_character)
            end

            if reference_name
              arg[reference_name] = @game.characters[potential_character]
            else
              character = @game.characters[potential_character]
            end

          # handle ad-hoc (neither a prop or character) arguments
          else

            arg[reference_type] = lexemes[lexeme_to_test]

        end
      end

      lexeme_to_test += 1

    end

    {'error' => error, 'arg' => arg, 'door' => door, 'prop' => prop, 'character' => character, 'any' => any}

  end

  def show_image(image_file)

    # Show image, if any
    if FileTest.exists?(image_file)
      @image_stack.height = @game.config['image_height']
      @image_stack.clear { @image_stack.image image_file }
      @output_stack.height = (@game.config['height'] - @game.config['image_height'])
    else
      @image_stack.height = 0
      @image_stack.clear { }
      @output_stack.height = @game.config['height']
    end

  end

end
