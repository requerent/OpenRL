OpenRL
======

A rogue-like library written in HaXe* designed to logically abstract various back-ends.

Rebrogue.swf provides a simple demonstration of the current progress. It isn't interactive at the moment, but it just shows some of the basic drawing features- see Source/Main.hx.

*HaXe is an ECMAScript style language with powerful meta-features.

So what is it?
==============

Right now it's not much more than a Console Emulator (A logical abstraction of the Curses interface used to represent an ascii graphical environment) with an OpenFL* back-end implemented.

I started the project as a framework for prototyping various game-play ideas primarily associated with procedural content generation and AI. I plan on implementing a Window Manager scheme on top of the graphical console and will probably build a server-client architecture for managing game logic.

*OpenFL is an abstraction of the flash API designed to target mobile, web, and native platforms. It's very intuitive and ideal for rapid development.



Right now, this is more of a proof-of-concept dummy project than a drop-in library.
