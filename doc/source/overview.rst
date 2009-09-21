Game Creation Overview
======================

Directory Structure
-------------------

The `docs` directory contains Fashion Quest developer documentation. 

The `engine` directory contains Fashion Quest application logic. Unless you want to play around with Fashion Quest's internals, you can ignore this directory.

The `standard_commands` directory contains standard game command definitions that can be shared between games.

Files pertaining used by specific games are put in *game directories*. These directories can be put into the same parent directory as the above directories and can be named anything. When Fashion quest starts, it will look through all directories at this level to see which ones contain config.yaml files (in which game name, etc., are stored). If only one game directory is found, Fashion Quest will automatically select it. Otherwise, a game selector will be presented to the user.

Game Configuration
------------------

Basic game coniguration is done via a `config.yaml` file. Each game directory must have one.

Game configuration options include game title, window width/height, whether the window should be resizable, startup message, and startup logic.

The basic look of a game can be tweaked using the startup logic. See the "Pirate Adventure Knockoff" demonstation game for an example.

Game Elements
-------------

GAME STATE?

The elements that make up a game include the player, locations, props, non-player characters, doors, commands, and transitions. All are defined using YAML with embedded Ruby.

Elements that the player may be able to carry are called *game components*. These include props, characters, and doors. Usually only props can be carried, but some games might require a character or door be carryable.

Commands and transitions rely on Ruby logic to manipulate the other game elements. Commands are triggered by the user whereas transitions are triggered by sspecific game states.

