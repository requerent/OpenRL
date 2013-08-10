OpenRL
======

A rogue-like library written in HaXe designed to logically abstract various back-ends.


Currently, an OpenFL backend is implemented for testing purposes, though it sufficiently targets native, web, and mobile platforms.



So what is it?

Right now it's not much more than a Console Emulator (A logical abstraction of the Curses interface used to represent an ascii graphical environment) with an OpenFL back-end implemented.

I started the project as a framework for prototyping various game-play ideas primarily associated with procedural content generation and AI. I plan on implementing a Window Manager scheme on top of the graphical console and will probably build a server-client architecture for managing game logic.
