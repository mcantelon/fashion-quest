Game World Elements
===================

Game world elements are defined using YAML_, a human-readable standard used to describe data structures using text. Each game component must have a globally unique identifier.

.. _YAML: http://www.yaml.org/

Locations
---------

Locations are...

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

Characters
----------

Characters are beings that players can interact with in the game.

Each character is defined in its own YAML file within the 'characters' subdirectory of the game directory.

The example below, from the "Pirate Adventure Knockoff" demonstration game, defines a character located in a location with the unique identifier `shack`. The pirate will accept the `rum` prop if the player gives it to him.

.. literalinclude:: ../../pirate_adventure/characters/pirate.yaml

State
-----

Game state is used to keep track of game conditions other than the state of other game elements. State can be referenced, or set, from logic within commands, transitions, and events.

One example from the `Pirate Adventure Knockoff` demonstration is tide state. Tide state is changed using transitions that set state using simple logic, such as the line shown below.

.. code-block:: ruby

    @state['tide'] = 'in'
