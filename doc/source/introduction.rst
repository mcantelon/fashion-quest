Introduction
============

Fashion Quest is an interactive fiction framework created to make `text adventure games`_ about fashion because we love fashion and we love text adventure games. Fashion Quest is written in the Ruby programming language and requires Shoes_, a cross-platform GUI framework created by `Why the Lucky Stiff`_. Fashion Quest has been tested with Shoes 2.

Games are created in Fashion Quest by defining game elements using YAML and bits of Ruby. The framework includes three demonstration games. The game "Fashion Quest: Daydream" is very small and designed to demonstrate non-player character features. It lives in the `daydream` directory. The game "Pirate Adventure Knockoff" is a port of the 1978 text adventure `"Pirate Adventure"`_ by Scott and Alexis Adams and lives in the `pirate_adventure` directory. The game `"Cloak of Darkness"`_ is a port of a game that was created as a means of comparing different interaction fiction frameworks. It lives in the `cloak_of_darkness` directory. There is also a game skeleton exists primarily to serve as the basis of new games. It lives in the `new_game` directory. 

To play either of these use Shoes to run `run.rb` and select which you’d like to play.

Thanks to Why the Lucky Stiff for creating Shoes and inspiring the creative use of computers!

.. _text adventure games: http://en.wikipedia.org/wiki/Interactive_fiction
.. _Shoes: http://shoesrb.com/
.. _Why the Lucky Stiff: http://en.wikipedia.org/wiki/Why_the_lucky_stiff/
.. _"Pirate Adventure": http://en.wikipedia.org/wiki/Pirate_Adventure
.. _"Cloak of Darkness": http://www.firthworks.com/roger/cloak/

Why Use a Framework?
--------------------

Development of interactive fiction (IF) involves dealing with problems not inherent in many other realms of development, including parsing and game world simulation. Because of this a number of frameworks have been developed to deal with the IF domain.

Fashion Quest is a relative newcomer. Established frameworks include *Inform*, *Adrift*, and *TADS*.

`ADRIFT`_ is one of the most user friendly of the frameworks. It allows games to be created using a GUI. It is not, however, extensible, cross-platform, or open source.

`Inform`_ is one of the most elegant and established of the frameworks. It allows games to be developed either in natural language (Inform 7) or a specialize programming language (Inform 6). It is extensible, cross-platform, open source, and supports automated game testing.

`TADS`_ is reputedly more powerful than Inform, but has a fairly steep learning curve.

The `Cloak of Darkness`_ site is useful for comparing interaction fiction frameworks as it contains implementations of the same simple interactive fiction game created using twenty different IF frameworks.

.. _Inform: http://www.inform-fiction.org/I7/Welcome.html
.. _ADRIFT: http://www.adrift.org.uk/
.. _TADS: http://www.tads.org/
.. _Cloak of Darkness: http://www.firthworks.com/roger/cloak/index.html

Design Goals of Fashion Quest
-----------------------------

Fashion Quest was created with the goal of being somewhere between ADRIFT and Inform in ease of use.

The design goals are as follows:

- **Minimalist**

  Fashion Quest was designed to be lightweight and easy to learn. The simulated world is as simple as possible. Game command syntax is defined using patterns rather than natural language rules.

- **Cross-platform**

  By leveraging Shoes, Fashion Quest is able to provide a consistant user experience across whether being used in Windows, Mac OS, or Linux.

- **Programmer-Friendly**

  Fashion Quest development is done using the Ruby programming language rather than a domain-specific programming language. This lessens the framework learning curve as there are many resources for those wishing to learn Ruby (and those who already know Ruby get a head start).

- **Extensible**

  Because Fashion Quest is open source, it is fully extensible. Default game engine behaviour can be overriden using monkey patching.
