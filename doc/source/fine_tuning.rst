Fine-Tuning
===========

Parsing
-------

Fashion Quest includes employs a crude, case-insensitive, parsing mechanism that converts player input into "lexemes",text elements (single words or game element identifiers such as "hat" or "blue hat") that can be compared to syntax forms.

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

Testing interactive fiction games can be tedious. To make testing easier Fashion Quest provides a couple of simple tools in the form of built-in commands.

In addition to the built-in commands, the Shoes `alert` function is handy for confirming logic is being executed. `alert('Hello`)` will, for example, pop up a dialog box with the word "hello".

When there are syntax errors in game logic, or other errors that stop game execution, you can often get useful clues by pressing Alt-/ to view the Shoes debugging console.

Walkthroughs
~~~~~~~~~~~~

When a player loads or saves a game, via the built-in `load` and `save` commands, all game element definitions are included in the game save. Because of this, these commands aren't very useful for testing.

Walkthroughs, on the other hand, can save a sequence of commands needed to arrive at a certain point in a game. This makes them useful for functional testing. Walkthrough files are simply a YAML list of commands.

To create a walkthrough, simply start you game and play it until the point at which you'd like your walkthrough to end. Entering the command `save walkthrough` will then allow you to save the walkthrough. When you wish to use a walkthrough, start or restart Fashion Quest and enter the command `load walkthrough`.

An example walkthrough is provides for the "Pirate Adventure Knockoff" demonstration game. It lives in the `pirate_adventure` directory and is named `complete_walkthrough`. It cycles through all the commands needed to win the game. Once the walkthrough has loaded, enter the command `score` and the win will be confirmed.

Transcripts
~~~~~~~~~~~

While walkthroughs are good for confirming nothing is broken, transcripts provide a way to confirm no output in a game has changed.

The built-in command `save transcript` will save the game output to a file. You can then make changes to your game, enter the commands needed to arrive at the point in the game where you originally saved the transcript, and use the built-in command `compare transcript` to compare the game output to the original transcript.

Naming
------

          noun      noun_cap
proper    Noun      Noun
plural    the nouns The nouns
general   a noun    A noun
countable water     Water

