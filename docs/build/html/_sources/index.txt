.. Fashion Quest documentation master file, created by sphinx-quickstart on Fri Sep 18 23:04:22 2009.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Fashion Quest's documentation!
=========================================

Contents:

.. toctree::
   :maxdepth: 2

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

Introduction
============

Fashion Quest is an interactive fiction framework created to make `text adventure games`_ about fashion because we love fashion and we love text adventure games. Fashion Quest requires Shoes_, a cross-platform GUI framework created by `Why the Lucky Stiff`_.

Text adventure games involve issuing tiny action plans, like `go north` or `fight the police`.

Games are created in Fashion Quest by defining game elements using YAML and bits of Ruby. The framework includes two demonstration games. The game "Fashion Quest: Daydream" is very small and designed to demonstrate non-player character features. It lives in the `game` directory. The game "Pirate Adventure Knockoff" is a port of the 1978 text adventure `"Pirate Adventure"`_ by Scott and Alexis Adams and lives in the `pirate_adventure` directory.

To play either of these use Shoes to run `run.rb` and select which you’d like to play.

Thanks to Why the Lucky Stiff for creating Shoes and inspiring the creative use of computers!

.. _text adventure games: http://en.wikipedia.org/wiki/Interactive_fiction
.. _Shoes: http://shoes.heroku.com/
.. _Why the Lucky Stiff: http://en.wikipedia.org/wiki/Why_the_lucky_stiff/
.. _"Pirate Adventure": http://en.wikipedia.org/wiki/Pirate_Adventure

Interactive Fiction Frameworks
------------------------------------

Text adventure games are also known as interactive fiction (IF). Development of IF involves dealing with problems not inherent in many other realms of development, including parsing and simulation. Because of this a number of frameworks have been developed to deal with the IF domain. Major frameworks include Inform, Adrift, and TADS.

ADRIFT is one of the most user friendly of the frameworks. It allows games to be created using a GUI. It is not extensible, cross-platform, or open source, however.

Inform is one of the most elegant and established of the frameworks. It allows games to be developed either in natural language (Inform 7) or a specialize programming langague (Inform 6). It is extensible, cross-platform, open source, and supports automated game testing.

TADS.

Design Goals of Fashion Quest
-----------------------------

Fashion Quest was created with the goal of being somewhere between ADRIFT and Inform in ease of use.

The design goals are as follows:

- **Minimalist**

  Fashion Quest was designed to be lightweight and easy to learn. The simulated world is as simple as possible. Game command syntax is defined using patterns rather than natural language rules.

- **Cross-platform**

  By leveraging Shoes, Fashion Quest is able to provide a consistant user experience across whether being used in Windows, Mac OS, or Linux.

- **Programmer-Friendly**

  Fashion Quest development is done using the Ruby programming language rather than a domain-specific programming language. This lessen the framework learning curve for those who already known Ruby.

- **Extensible**

  Because Fashion Quest is open source, it is fully extensible. Default game engine behaviour can be overriden using monkey patching.


Game Creation Overview
======================

Directory Structure
-------------------

- game is defined by files within the the game's base path
- the game base path is, by default, "game" but can be changed by specifying an alternate path as a command line argument
- alternate paths allow you to work on, or play, multiple games with the same codebase
- unless you like to hack, igore the 'engine' directory
- if you wish to hack, see Appendix A for a guide to the engine directory's files

Game Configuration
------------------

Presentation Configuration:
- in the game's base path, config.yaml allows configuration of how game is presented
- configuration options include game title, widow width/height, whether window is resizable, and game startup message.

Game Components
---------------

- there are three types of game components: locations, doors, props, characters, and commands
- game components are defined in YAML
- game component files are put in subdirectories of the game base directory
- idea is to try to define attributes of game components and use commands to manipulate them

Creating Game Components
========================

Creating Locations
------------------

- locations are put in the 'rooms' subdirectory
- exits can be directions "north" or arbitrary names "stairs"

Creating Doors
--------------

- doors are put in the 'doors' subdirectory
- doors connect two or more locations
- if a door connects more than two locations, when entering from one location you will end up at a random pick of the other locations

Creating Props
--------------

- props are put in the 'props' subdirectory

Creating Characters
-------------------

- characters are put in the 'characters' subdirectory
- characters are defined in YAML
- any props a character will accept being given are indicated by the "exchanges" property

Creating Commands
-----------------

- commands are defined in YAML
- command files are put in the commands directory of the game's base directory
- within the commands directory, commands can be placed in subdirectories if desired
- commands are made up of syntax and logic
- command syntax can have multiple forms
  - each syntax form is composed of keywords and references
  - keywords are static words: verbs
  - references refer to "things": nouns
    - types of references: prop, character, door, ad-hoc
    - prop, character, and door references can refer to any prop, character, or door in the same location as the player
    - if a prop, character, or door doesn't have the same location as the player, an error will be returned
    - ad-hoc references can refer to anything... there is no checking before passing an ad-hoc reference to command logic
    - in syntax form, references enclosed in less-than and greater-than symbols
    - examples:
      - "<prop>" for unnamed prop reference
      - "<character>" for unnamed prop reference
      - "<prop:some name>" for a named prop reference
      - "<character:some other name>" for a named character reference
      - "<anything>" for an ad-hoc reference
- command logic is written in Ruby
  - variables are passed to the command logic
  - references are passed as variables
    - "<prop>" unnamed prop reference passed as "prop" variable
    - "<character>" unnamed character reference passed as "character" variable
    - "<prop:some name>" named prop reference passed as "arg['some name']" variable
    - "<character:some other name>" named character reference passed as "arg['some other name']" variable
    - "<anything>" ad-hoc refrence passed as "arg[anything]"
  - "game", "player", "characters", "props" variables allow interaction with game engine and game data
    - "game" spec
    - "player" spec
    - "characters" spec
    - "props" spec
  - example commands
- commands can be shared between games
  - if you want to share a command between games, put the command in the standard_commands dirctory
  - to include a shared command in a game, put an empty file in your game's command directory with the same filename
    as the shared command
  - alternately, if you're not using Windows you can use symlinks

Events
------

- characters and props can have events associated with them
- built-in character events are: on_death, etc.
- props can also have events
- events can contain text and/or logic
- to trgger events, simply add the logic into a command
- for example, the get command could trigger an "on_get" event in a prop:
   output << game.event(props[prop], 'on_get')
- the above example would have the game check a certain prop for an on_get response
- an example response could be:
   @locations['alcove'].add_to_description("There is a bookcase with a secret passage beyond.\n"); "There's a strange sound.\n";
- the above example would add to a rooms description and give the player a hint that something in the game has changed

Transitions
-----------

- transitions allow manipulation of components to be triggered by game conditions, rather than user commands
- this allows you to avoid having to add the same logic in multiple commands
- transitions return output
- if you want a transition to be silent, end it with the line ""

State
-----

- state can be used to keep track of global game conditions
- state can be referred to or manipulated in transitions or commands
- within transtions, use @state
- example: @state['tide'] = 'in'
- within commands, use game.state
- example: game.state['tide'] = 'out'

Fine-Tuning
===========

Style
-----
- whenever possible, keep game-specific "rules" in transitions instead of commands
- keeping game-specific logic out of commands allows them to be reused in different games

Abbreviations, Synonyms, and Garbage Words
------------------------------------------

- the command_abbreviations.yaml file, in the game parsing path, allows a list of abbreviations for specific command instances to be defined
- for example: "n" for "go north"
- in the above example, "north" was a parameter to the "go" command
- in the case of abbreviations that don't need to specify a parameter, like "i" for "inventory", those should be included as a syntax of the command itself

- the global_synonyms.yaml file, in the game parsing path, allow a list of words that should be replaced with other words
- for example: "using" for "with"
- in the above example, this synonym would elimiate the need to make the syntax "attack <character> with <prop>" also work when the player issues the command like "attack bear using hat"

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

