Creating Game Components
========================

Game components are defined using YAML_, a human-readable standard used to describe data structures using text. Each game component must have a globally unique identifier.

.. _YAML: http://www.yaml.org/

Creating Locations
------------------

Locations are...

Each location is defined in its own YAML file within the 'locations' subdirectory of the game directory.

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a location with two exits: an exit to the north and an open window. The unique indentifier of the location is `alcove`.

.. literalinclude:: ../../pirate_adventure/locations/alcove.yaml

Creating Doors
--------------

Doors allow two or more locations to be connected. If a door connects more than two locations, when entering from one location you will end up at a random pick of the other locations.

Doors are defined in a file called `doors.yaml` within the `doors` subdirectory of the game directory.

The example below, from the "Fashion Quest: Daydream" demonstration game, defines a door that allows the player to travel between two locations. The door is locked by default, but may be opened using the `brass key` prop. The unique indentifier of the door is `door`. 

.. literalinclude:: ../../game/doors/doors.yaml

Creating Props
--------------

Props are items that players can interact with in the game. They may be portable items, such as a pack of cigarettes, or items that can't be carried, such as a dresser.

Props are defined in a file called `props.yaml` within the `props` subdirectory of the game directory.

The example below, from the "Fashion Quest: Daydream" demonstration game, defines a dresser located in a location with the unique identifier `bedroom`. The dresser can be opened by the player and contains another prop, a pack of `smokes`.

.. literalinclude:: examples/dresser.yaml

Creating Characters
-------------------

Characters are beings that players can interact with in the game.

Each character is defined in its own YAML file within the 'characters' subdirectory of the game directory.

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a character located in a location with the unique identifier `shack`. The pirate will accept the `rum` prop if the player gives it to him.

.. literalinclude:: ../../pirate_adventure/characters/pirate.yaml

Creating Commands
-----------------

Each command is defined in its own YAML file within the 'commands' subdirectory of the game directory. If a command file within this directory exists, but is empty, the game engine will look for a command with the same filename in the `standard_commands` directory.

- within the commands directory, commands can be placed in subdirectories if desired???

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a command that enables the player to wake up the pirate character. If the character's `asleep` trait is `true` the `asleep` trait will be changed to `false` if the player enters the command `wake pirate`.

.. literalinclude:: ../../pirate_adventure/commands/wake.yaml

Commands are made up of syntax and logic.

Syntax
~~~~~~

Command syntax can have multiple forms. For example, a command that allows the player to pick up a prop could have the form `get <prop>` or `take <prop>`.

Each syntax form is composed of keywords and references. With the case of the above example `get` and `take` are the keywords and `<prop>` is the reference.

Keywords are static words identifying an action: verbs. References refer to "things": nouns.

Three types of references can be used: prop, character, door, ad-hoc.

Prop, character, and door references can refer to any prop, character, or door in the same location as the player. If a prop, character, or door is referenced, but doesn't have the same location as the player, an error will be returned.

Ad-hoc references can refer to anything... the game engine doesn't checking before passing an ad-hoc reference to command logic.

When defining syntax forms, references are enclosed in less-than and greater-than symbols. NAMED?

Examples:
- "<prop>" for unnamed prop reference
- "<character>" for unnamed prop reference
- "<prop:some name>" for a named prop reference
- "<character:some other name>" for a named character reference
- "<anything>" for an ad-hoc reference

Logic
~~~~~

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
