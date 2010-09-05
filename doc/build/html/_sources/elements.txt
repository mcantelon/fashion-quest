Game World Elements
===================

Each game component must have a globally unique identifier. There are two ways to define game components: either using YAML_, a human-readable standard used to describe data structures using text, or using Ruby. This documentation focuses on the use of YAML, but if you're interested in using Ruby check out the `Cloak of Darkness` implementation for an example.

.. _YAML: http://www.yaml.org/

Locations
---------

Locations are places a player can visit during a game.

Each location is defined in its own YAML file within the 'locations' subdirectory of the game directory.

The example below defines a location with a number of exits. The unique indentifier of the location is `entrance`. Each exit has a destination, which is the unique identifier of the location to which it leads. Note that the `stairs` exit has a description: "upstairs". This is used to describe travelling this way. For example a character taking this exit will be described using  "the hobo goes upstairs" rather than "the hobo goes stairs".

.. literalinclude:: ../../game/locations/entrance.yaml

Doors
-----

Doors allow two or more locations to be connected. If a door connects more than two locations, when entering from one location you will end up at a random pick of the other locations.

Doors are defined in a file called `doors.yaml` within the `doors` subdirectory of the game directory.

The example below defines a door that allows the player to travel between two locations. The door is locked by default, but may be opened using the `brass key` prop. The unique indentifier of the door is `door`. 

.. literalinclude:: examples/door.yaml

Props
-----

Props are items that players can interact with in the game. They may be portable items, such as a pack of cigarettes, or items that can't be carried, such as a dresser.

Props are defined in a file called `props.yaml` within the `props` subdirectory of the game directory.

The example below defines a dresser located in a location with the unique identifier `bedroom`. The dresser can be opened by the player and contains another prop, a pack of `smokes`.

.. literalinclude:: examples/dresser.yaml

Props, as the example below shows, can have one or more aliases. The aliases can be used by players to refer to the prop.

.. literalinclude:: examples/alias.yaml

Props can have traits set that determine what can be done with them.

Portability
~~~~~~~~~~~

If a prop has its `portable` trait set to true, the player will be able to take it. When props are defined using `props.yaml` the `portable` trait gets automatically set to true if not otherwise specified.

Visibility
~~~~~~~~~~

If props have their `visible` trait set to true, these props will be automatically shown when the player looks. When props are defined using `props.yaml` the `visible` trait gets automatically set to true if not otherwise specified.

Text
~~~~

If a prop has its `text` trait set, the prop can be read. `text` may be set to text to be shown to the player or, if the first character is ">", a text file in the game folder.

.. literalinclude:: examples/prop_text.yaml

Containers
~~~~~~~~~~

If a prop has the `open` trait set to false it can contain other props. These props are specified using the `contains` trait. The props may require other props to open them, if the `open_with` trait is set.

.. literalinclude:: examples/prop_open_with.yaml

Size
~~~~

The `size` trait can be used to prevent large props from passing through doors that have lesser `size` traits defined.

The "crack" door in the Pirate Adventure demo game, for example, has a size of 1.

.. literalinclude:: examples/door_size.yaml

The size of the crack prevents the player from entering it if carrying props, such as the book and the shovel, that have a size of 2.

Construction
~~~~~~~~~~~~

A prop can be specified as being built from other props. This is done by setting the `build_with` trait to the component props. If any of the component props should be taken out of play, they should be includes in the `build_consumes` trait.

.. literalinclude:: examples/prop_build.yaml

Get With
~~~~~~~~

If you need to have one or more props to get another (a bottle, for example, to get water), you can set the `get_with` trait of a prop.

.. literalinclude:: examples/prop_get_with.yaml

Buried Props
~~~~~~~~~~~~

If a prop has its `can_dig` trait set to true it can be used to dig. If a prop has its `buried` trait set to true it can be dug up. When a prop is dug up its `portable` and `visible` traits get set to true. Below is an example of a buried prop.

.. literalinclude:: examples/prop_buried.yaml

Wearables
~~~~~~~~~

If a prop can be worn by the player, set the `wearable` trait to true.

.. literalinclude:: examples/prop_wearable.yaml

Flammables
~~~~~~~~~~

Locations can be set to be dark, in which case a player needs a source of illumination to see the description. If a prop has the trait `lit` set to false the player will be able to light on fire using a prop that has the `firestarter` trait set to true. If the prop has its `burn_turns` trait set to a number then it will only burn for that number of turns.

.. literalinclude:: examples/prop_flammable.yaml

Support
~~~~~~~

If a prop has the `supports` trait set to true, other props can be put on it. If the prop has the `supports_only` trait set to one or more props, only these props will be supported by it.

.. literalinclude:: examples/prop_support.yaml

Characters
----------

Characters are beings that players can interact with in the game.

Each character is defined in its own YAML file within the 'characters' subdirectory of the game directory.

The example below defines a character located in a location with the unique identifier `shack`. The pirate will accept the `rum` prop if the player gives it to him.

.. literalinclude:: examples/character.yaml

Mobility
~~~~~~~~

Characters will wander from location to location if their `mobility` is set. Mobility is the probability (in percentage) that the character will move each turn. The character example below will go to a new location each turn.

.. literalinclude:: examples/character_mobility.yaml

Aggression
~~~~~~~~~~

Characters will be prone to attack the player if their `aggression` is set. Aggression is the probability (in percentage) that the character will start to attack each turn. A character's `strength` determines how much damage it can do each attack if they don't posess a weapon prop (the `default_attack` property determines how the weaponless attack will be described). If a character does have a weapon prop with a greater attack strength than their default, the character will automatically use it in attacks.

The character example below has a 5% chance of turning hostile and will do one or two hit points of damage each turn.

.. literalinclude:: examples/character_aggression.yaml

A prop can serve as a weapon if the prop's `attack strength` is set. If a character possesses a weapon, this weapon will be used if its `attack strength` is greater than the character's `strength`. The prop example below is possessed by the "deadbeat" character and gives the character a strength of 7.

.. literalinclude:: examples/character_weapon.yaml

Communication
~~~~~~~~~~~~~

Characters can be asked questions about topics. Topics and responses are put into the `discusses` setting. The example below shows a character that, when asked about a "party", "parties", or "partying", responds with one of two opinions about the topic.

.. literalinclude:: examples/character_communication.yaml

If the letter ">" is the first character of a response, double quotes will be put around the remaining characters of the response before outputting to the player.

Characters can also be made to occasionally mutter random things or be described as doing random things. The example below shows a character that has a 10% chance, each turn, of either being described as looking at the player or as saying something.

.. literalinclude:: examples/character_mutters.yaml

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

One example, from the `Pirate Adventure Knockoff` demonstration game, is tide state. Tide state is changed using transitions that set state using simple logic, such as the line shown below.

.. code-block:: ruby

    @state['tide'] = 'in'
