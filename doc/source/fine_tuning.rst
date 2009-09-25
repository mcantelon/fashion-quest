Fine-Tuning
===========

Style
-----
- whenever possible, keep game-specific "rules" in transitions instead of commands
- keeping game-specific logic out of commands allows them to be reused in different games

Parsing
-------

Fashion Quest includes employs a crude, case-insensitive, parsing mechanism that converts player input into "lexemes",text elements (single words or game element identifiers such as "hat" or "blue hat") that can be compared to syntax forms.

ARE ONLY PROPS CAPABLE OF LEXEMES?

Here's the basic flow of parsing:
1. Abbreviated commands are expanded (`i` to `inventory`, for example)
2. Input is broken into lexemes (single words or game element indentiers)
3. Any lexemes that match synonyms are replaced (`examine` to `look`, for example)
4. Any lexemes that match garbage words are deleted (`the`, `this`, etc.)

Abbreviations
~~~~~~~~~~~~~

- the command_abbreviations.yaml file, in the game parsing path, allows a list of abbreviations for specific command instances to be defined
- for example: "n" for "go north"
- in the above example, "north" was a parameter to the "go" command
- in the case of abbreviations that don't need to specify a parameter, like "i" for "inventory", those should be included as a syntax of the command itself

Synonyms
~~~~~~~~

- the global_synonyms.yaml file, in the game parsing path, allow a list of words that should be replaced with other words
- for example: "using" for "with"
- in the above example, this synonym would elimiate the need to make the syntax "attack <character> with <prop>" also work when the player issues the command like "attack bear using hat"

Garbage Words
~~~~~~~~~~~~~

- the garbage_words.yaml file, found in the game's parsing path, allows certain words to be discarded from player input
- these words should be words like "the" and "a" which have little semantic meaning
- this makes specifying command syntax easier

Testing
-------

- when saving and loading games be mindful that prop, etc., definitions get saved as well so your game changes may not be
  reflected
- use "save walkthrough" command to save your previous commands
- use "load walkthrough" command to run through commands you've previously saved
- these commands can be used for testing
- walkthrough files are YAML, so easy to edit
- COMPARE, TRANSCRIPT?
- use the Shoes debugger... press alt-/ to see error messages
- alert('some message') is also handy to deduce the flow of logic

- no need to check for prop or character locations in commands because command parser will return error if prop or character referenced doesn't exist or isn't located near player

Naming
------

          noun      noun_cap
proper    Noun      Noun
plural    the nouns The nouns
general   a noun    A noun
countable water     Water

