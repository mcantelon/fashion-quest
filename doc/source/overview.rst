Framework Overview
==================

Directory Structure
-------------------

The `doc` directory contains Fashion Quest developer documentation. 

The `engine` directory contains Fashion Quest application logic. Unless you want to play around with Fashion Quest's internals, you can ignore this directory.

The `standard_commands` directory contains standard game command definitions that can be shared between games.

Files pertaining used by specific games are put in *game directories*. These directories can be put into the same parent directory as the above directories and can be named anything. When Fashion quest starts, it will look through all directories at this level to see which ones contain config.yaml files (in which game name, etc., are stored). If only one game directory is found, Fashion Quest will automatically select it. Otherwise, a game selector will be presented to the user.

Game Elements
-------------

The elements that make up a game include the player, locations, props, non-player characters, doors, game state, commands, and transitions. All are defined using YAML with embedded Ruby.

Elements that the player may be able to carry are called *game components*. These include props, characters, and doors. Usually only props can be carried, but some games might require a character or door be carryable.

Game state allows ad-hoc game world conditions to be stored. In the demonstration game "Pirate Adventure Knockoff", for example, game state is used to record whether or not the tide is in.

Commands and transitions rely on Ruby logic to manipulate the other game elements. Commands are triggered by the user whereas transitions are triggered by the conditions of other game elements.

Game Directory Structure
------------------------

The game directory contains a number of folders and files in which game configuration live.

- **Basic Configuration**

  Each game directory must contain a `config.yaml` file. This file contains high-level configuration parameters such as game title, window width/height, whether the game window should be resizable, startup message, and startup logic.

  The basic look of a game can be tweaked using the startup logic. See the "Pirate Adventure Knockoff" demonstation game for an example.

- **Transitions**

  A game directory may contain a `transitions.yaml` file. This file defines any transitions.

- **Characters**

  A game directory may contain a `characters` directory in which files that define non-player characters are kept.

- **Commands**

  A game directory requires a `commands` directory in which files that define commands, or reference standard commands, are kept.

- **Doors**

  A game directory may contain a `doors` directory in which a file that defines doors is kept.

- **Locations**

  A game directory requires a `locations` directory in which files that define locations are kept.

- **Parsing**

  A game directory may contain a `parsing` directorry in which files related to the fine-tuning of command parsing are kept.

- **Player**

  A game directory requires a `player` directory in which a file that defines the player's attributes is kept.

- **Props**

  A game directory requires a `props` directory in which a file that defines game props is kept.

