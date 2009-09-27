Overview
========

Game Elements
-------------

The elements that make up a game include the player, locations, props, non-player characters, doors, game state, commands, and transitions. All are defined using YAML with embedded Ruby.

Elements that the player may be able to carry are called `game components`. These include props, characters, and doors. Usually only props can be carried, but some games might require a character (a parrot, for example) or door (a teleportation device, for example) be carryable.

Game state allows ad-hoc game world conditions to be stored. In the demonstration game "Pirate Adventure Knockoff", for example, game state is used to record whether or not the tide is in.

Commands and transitions rely on Ruby logic to manipulate the other game elements. Commands are triggered by the user whereas transitions are triggered by the conditions of other game elements.

Framework Directory Structure
-----------------------------

The `framework directory` is the directory containing `run.rb`. Its file structure is explained below.

.. list-table:: Framework directory file structure
   :widths: 20 80

   * - **Directory/File**
     - **Description**
   * - doc
     - Directory containing developer documentation
   * - engine
     - Directory containing framework engine logic
   * - standard_commands
     - Directory containing standard game command definitions that can be shared between games

Files used to define games are put in `game directories`. These directories can be put inside the `framework directory`. Every `game directory` must contain a `config.yaml` file (in which basic game configuration is stored). When Fashion quest starts, it will look through all directories in the `framework directory` to see which ones contain a `config.yaml` file. If only one game directory is found, Fashion Quest will automatically start this game. Otherwise, a game selector will be presented to the user.

Game Directory Structure
------------------------

The `game directory` file structure is explained below.

.. list-table:: Game directory file structure
   :widths: 20 80

   * - **Directory/File**
     - **Description**
   * - config.yaml
     - File containing YAML basic game configuration
   * - transitions.yaml
     - File containing YAML transition definitions
   * - characters
     - Directory containing YAML character definition files
   * - commands
     - Directory containing YAML command definition files
   * - doors
     - Directory containing the YAML door definitions file
   * - locations
     - Directory containing YAML location definition files
   * - parsing
     - Directory containing parsing-related YAML configuration files
   * - player
     - Directory containing the YAML player definition file
   * - props
     - Directory containing the YAML props definition file

Built-in Commands
-----------------

There are a number of built-in game commands that don't appear in the `standard_commands` directory. These are: `restart`, `clear`, `load`, `save`, `load walkthrough`, `save walkthrough`, save `transcript`, and `compare to transcript`.

`restart` restarts the game. `clear` clears the command output. `load` and `save` allow the user to load or save their game progress to a file.

The other built-in commands are developer-oriented and discussed in the testing section.
