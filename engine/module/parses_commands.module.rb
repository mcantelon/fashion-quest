module Parses_Commands

  include Handles_YAML_Files

  def parse(input_text)

    if not input_text.empty?

      # convert to lower case and allow for command abbreviations
      input_text = expand_abbreviated_commands(input_text.downcase)

      # prepare lexemes for interpretation as command
      lexemes = parse_out_garbage_lexemes(
        parse_normalize_global_synonyms(
          parse_reference_words(input_text.split(' '))
        )
      )

      # return result of first valid command
      if @commands
        @commands.each do |command|
          result = command.try(lexemes)
          if result
            return result
          end
        end
      end

      # return error if no command is valid
      return output_error

    end
  end

  def expand_abbreviated_commands(input_text)

    abbreviations_file = "#{@game.path}parsing/command_abbreviations.yaml"
    abbreviations = load_yaml_file(abbreviations_file)

    if abbreviations

      abbreviations.each do |abbreviation, expansion|

        if input_text == abbreviation

          return expansion
        end
      end

    else
      error('No abbreviations found at ' + abbreviations_file)
    end

    input_text

  end

  def parse_out_garbage_lexemes(lexemes)

    garbage_words_file = "#{@game.path}parsing/garbage_words.yaml"
    garbage_words = load_yaml_file(garbage_words_file)

    if garbage_words

      garbage_words.each do |word|
        lexemes.delete(word)
      end

    else

      error('Garbage words not found at ' + garbage_words_file)
    end

    lexemes

  end

  def parse_reference_words(words, current_word = 1, level = 1)

    number_of_words = words.length

    # if a multi-word command, look for multi-word prop references
    if number_of_words > 1 then

      # try using each word as the start word
      while current_word < number_of_words do

        # for each sequence starting with the current
        # word, check for prop reference
        remaining_words = ''
        start_word = current_word - 1

        processing_word = 1

        while start_word < number_of_words do

          if remaining_words.length > 0
            remaining_words << ' '
          end

          remaining_words << words[start_word]

          # only check for references for compound words
          if processing_word > 1

            # if the sequence is an prop reference, replace
            # the component words with the reference as a string
            if @game.props[remaining_words] != nil

              reference_end_word = current_word + remaining_words.scan(/\ /).length 
              words_after_prop_reference =
                words[reference_end_word, number_of_words - reference_end_word]

              # recurse with new word array to see if more references exist
              new_word_array =
                words[0, start_word - 1] + [remaining_words] + words_after_prop_reference

              level += 1
            return parse_reference_words(new_word_array, 1, level)
            end
          end

          processing_word += 1

          start_word += 1
        end

        current_word += 1
      end
    end

    words
  end
 
  def parse_normalize_global_synonyms(lexemes)

    synonyms_file = "#{@game.path}parsing/global_synonyms.yaml"
    synonyms = load_yaml_file(synonyms_file)

    if synonyms

      key = 0
      lexemes.each do |word|
        synonyms.each do |synonym,normalized|
          if word == synonym
            lexemes[key] = normalized
          end
        end
        key += 1
      end
    else

      error('Synonyms not found at ' + synonyms_file)
    end

    lexemes
  end

end
