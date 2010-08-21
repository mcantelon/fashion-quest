Game World Manipulation
=======================

Game components are defined using YAML_, a human-readable standard used to describe data structures using text. Each game component must have a globally unique identifier.

.. _YAML: http://www.yaml.org/

Commands
--------

Each command is defined in its own YAML file within the 'commands' subdirectory of the game directory. If a command file within this directory exists, but is empty, the game engine will look for a command with the same filename in the `standard_commands` directory.

.. note::

   Symbolic links can also be used, instead of empty command files, to point to standard commands but Windows doesn't support symbolic links so the game won't be cross platform.

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a command that enables the player to wake up the pirate character. If the character's `asleep` trait is `true` the `asleep` trait will be changed to `false` if the player enters the command `wake pirate`.

.. literalinclude:: ../../pirate_adventure/commands/wake.yaml

Commands are made up of syntax and logic.

TIP: Keep the idea of reusing commands between games in mind when creating commands. If logic is game-specific, try to use transitions instead of commands to implement the logic.

Syntax Forms
~~~~~~~~~~~~

Command syntax can have multiple forms. For example, a command that allows the player to pick up a prop could have the form `get <prop>` or `take <prop>`.

Each syntax form is composed of keywords and parameters. Parameters are usually references to game elements. With the case of the above example `get` and `take` are the keywords and `<prop>` is the reference parameter.

Keywords are static words identifying an action: verbs. References refer to "things": nouns.

Four types of parameters can be used: prop references, character references, door references, and text.

Prop, character, and door references can refer to any prop, character, or door in the same location as the player. If a prop, character, or door is referenced, but doesn't have the same location as the player, an error will be output.

When defining syntax forms, parameters are enclosed in less-than and greater-than symbols. A reference paramter can be given the same name as its type or can be given a name. A syntax form containing the prop reference parameter `<prop>` would pass to the command a reference named `prop`. A syntax form `<prop:thing>` would pass to the command a reference named `arg['thing']`.

Text parameters are always named. A syntax form containing the ad-hoc reference `<colour>` would pass to the command the variable `arg['color']`.

Examples:
- "<prop>" for unnamed prop reference
- "<character>" for unnamed prop reference
- "<prop:some name>" for a named prop reference
- "<character:some other name>" for a named character reference
- "<anything>" for an ad-hoc reference

Logic
~~~~~

Command logic is written in Ruby. References to props, characters, or doors can be passed in as specified by syntax forms.

In addition to data passed in via syntax forms, game elements can also be arbitrarily accessed.

`@game` provides access to game properties and methods.

`@player` provides access to player properties and methods.

`@props` provides access to the properties and methods of individual props.

`@characters` provides access to the properties and methods of individual characters.

The best way to understand how commands work is to check out the commands in the `standard_commands` directory.

Conditions
~~~~~~~~~~

Command conditions are logic that determines if a command can be carried out by the player. Conditions can be defined for individudal commands and/or globally for any command.

Condition logic should return a hash with a "success" element (boolean to indicate whether or not the attempted command should be carried out) and, optionally, a "message" element that returns information to the player.

Command conditions for individual commands may be defined in a command's YAML file, as shown below.

.. literalinclude:: examples/jump.yaml

A global command condition can be specified in the `command_condition` element of a game's config.yaml file.

Events
------

Events enable Ruby logic to be triggered by happenings in the game world. Characters, props, and doors can all have event outcome associated with them.

For example, the `cat` character in the "Fashion Quest: Daydream" demonstration game responds to two events: `on_attack` (when the cat is attacked) and `on_death` (when the cat is killed).

.. literalinclude:: ../../game/characters/cat.yaml

Commands can be used to trigger events. For example, the standard get command triggers the `on_get` event on a prop (and collects event output into the variable `on_get_output` by including the following line:

.. code-block:: ruby

   on_get_output = @game.event(prop, 'on_get')

The "Pirate Adventure Knockoff" demonstration game uses the `on_get` event of the `book` prop to change the description of a room, revealing a secret passage, and return a hint to the player that something has changed.

.. literalinclude:: examples/on_get.yaml

If event YAML is set to be a list of event outcomes then an outcome will be randomly selected from the list when the event is triggered, as an example shows below.

.. code-block:: ruby

   on_discuss:
   - "The deadbeat squints at you and shuffles his feet before answering.\n"
   - "The deadbeat tilts his head sceptically before answering.\n"

Transitions
-----------

Transitions enable Ruby logic to be triggered by happenings in the game world. Transitions are more versitile than events: any game condition(s) can be used to trigger the manipulation of any game element(s).

To add transitions to a game, create the file `transitions.yaml` in the appropriate game directory. Transitions are made up of one or more triggering conditions and one or more outcomes.

The example transition below, containing conditions and outcomes extracted from the "Pirate Adventure Knockoff" demonstration game, shows a transition that makes a pet leave if neither his master nor food are present.

.. literalinclude:: examples/transition.yaml

If you want a transition output to not return output, end it with a line containing only `""`.
