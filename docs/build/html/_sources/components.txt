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
