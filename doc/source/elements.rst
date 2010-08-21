Game World Elements
===================

Game world elements are defined using YAML_, a human-readable standard used to describe data structures using text. Each game component must have a globally unique identifier.

.. _YAML: http://www.yaml.org/

Locations
---------

Locations are places a player can visit during a game.

Each location is defined in its own YAML file within the 'locations' subdirectory of the game directory.

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a location with two exits: an exit to the north and an open window. The unique indentifier of the location is `alcove`.

.. literalinclude:: ../../pirate_adventure/locations/alcove.yaml

Doors
-----

Doors allow two or more locations to be connected. If a door connects more than two locations, when entering from one location you will end up at a random pick of the other locations.

Doors are defined in a file called `doors.yaml` within the `doors` subdirectory of the game directory.

The example below, from the "Fashion Quest: Daydream" demonstration game, defines a door that allows the player to travel between two locations. The door is locked by default, but may be opened using the `brass key` prop. The unique indentifier of the door is `door`. 

.. literalinclude:: ../../game/doors/doors.yaml

Props
-----

Props are items that players can interact with in the game. They may be portable items, such as a pack of cigarettes, or items that can't be carried, such as a dresser.

Props are defined in a file called `props.yaml` within the `props` subdirectory of the game directory.

The example below, from the "Fashion Quest: Daydream" demonstration game, defines a dresser located in a location with the unique identifier `bedroom`. The dresser can be opened by the player and contains another prop, a pack of `smokes`.

.. literalinclude:: examples/dresser.yaml

Props, such as the example below from the "Pirate Adventure" demonstration game, can have one or more aliases. The aliases can be used by players to refer to the prop.

.. literalinclude:: examples/alias.yaml

Characters
----------

Characters are beings that players can interact with in the game.

Each character is defined in its own YAML file within the 'characters' subdirectory of the game directory.

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a character located in a location with the unique identifier `shack`. The pirate will accept the `rum` prop if the player gives it to him.

.. literalinclude:: examples/character.yaml

Mobility
~~~~~~~~

Characters will wander from location to location if their `mobility` is set. Mobility is the probability (in percentage) that the character will move each turn. The character example below will go to a new location each turn.

.. literalinclude:: examples/character_mobility.yaml

Aggression
~~~~~~~~~~

Characters will be prone to attack the player if their `aggression` is set. Aggression is the probability (in percentage) that the character will start to attack each turn. A character's `strength` determines how much damage it can do each attack. The character example below has a 5% chance of turning hostile and will do one or two hit points of damage each turn.

.. literalinclude:: examples/character_aggression.yaml

A prop can serve as a weapon if the prop's `attack strength` is set. If a character possesses a weapon, this weapon will be used if its `attack strength` is greater than the character's `strength`. The prop example below is possessed by the "deadbeat" character and gives the character a strength of 7.

.. literalinclude:: examples/character_weapon.yaml

Communication
~~~~~~~~~~~~~

Characters can be asked questions about topics. Topics and responses are put into the `discusses` setting. The example below shows a character that, when asked about a "party", "parties", or "partying", responds with one of two opinions about the topic.

.. literalinclude:: examples/character_communication.yaml

Trade
~~~~~

Characters may be willing to accept props as gifts or for trade.

In the example below the character will accept the gift of rum.

.. literalinclude:: examples/character_gift.yaml

In the example below the character will give a pair of shoes and a shiv in exchange for smokes.

.. literalinclude:: examples/character_exchange.yaml

Portability
~~~~~~~~~~~

Characters can be set to allow the player to carry them, as with the example below.

.. literalinclude:: examples/character_portability.yaml

Logic
~~~~~

Characters can execute custom Ruby logic each turn. In the example below the parrot character will, if in the same location as the player, occassionally eat a cracker if the player possesses crackers.

.. literalinclude:: examples/character_logic.yaml

State
-----

Game state is used to keep track of game conditions other than the state of other game elements. State can be referenced, or set, from logic within commands, transitions, and events.

One example from the `Pirate Adventure Knockoff` demonstration is tide state. Tide state is changed using transitions that set state using simple logic, such as the line shown below.

.. code-block:: ruby

    @state['tide'] = 'in'
