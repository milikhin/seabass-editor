![build](https://github.com/milikhin/seabass2/workflows/build/badge.svg)

# Seabass
## About

Seabass is a code editor for mobile devices.

Currently supported platforms:

* Sailfish OS
* UBports

[![OpenStore](https://open-store.io/badges/en_US.png)](https://open-store.io/app/seabass2.mikhael)

![Seabass on Sailfish X #1](http://milikhin.name/img/seabass/seabass-xperia-u01.png)
![Seabass on Sailfish X #2](http://milikhin.name/img/seabass/seabass-xperia-02.png)

## Features
Core features:
* Syntax highlighting for over 120 programming/markup languages
* Undo/Redo
* Light and dark themes
* Navigation buttons
* Code autocompletion and snippets

UBports:
* Multiple tabs
* Adaptive layout

## Build instructions

Requirements:

* Node.js, tested using v12
* Sailfish SDK (for Sailfish OS)
* clickable (for UBports)

Build steps:

1. Build editor engine  
   1. Install editor dependencies and build tools: `npm install`
   1. UBports only: remove `ubports-seabass/qml/html` directory (if exists, required only once when updating sources from ubports-seabass v0.1.x)
   1. Build editor engine and copy required files to Sailfish/UBports app directory: `npm run build`
1. Build App  
   * Sailfish OS: build `harbour-seabass` using Sailfish SDK
   * UBports: build `ubports-seabass` using clickable

## Contribution

Like the Seabass? Would like to see new features implemented?
Awesome! There are numerous ways you can support the development.

First of all, your reviews, bug reports and feature requests are very appreciated!
As so pull requests :-). Please see [wiki](https://github.com/milikhin/seabass2/wiki) for project docs. [Unit tests](https://github.com/milikhin/seabass2/tree/master/editor/__tests__) might also be useful.

There are a few labels used to indicate issue progress.
* `help wanted`: in my opinion, the issue is worth fixing, but I'm not going to fix it myself due to its complexity, time required, if I just don't know how to fix it, or everything above. Pull requests are welcome if you'd like to see the feature implemented!
* `wontfix`: in my opinion, the issue requires to much work out of the project's scope or too many workarounds for SDK issues. Pull requests are still welcome though. It might be worth discussing implementation beforehand if there going to be lots of changes.

## Becoming a sponsor

Seabass is a free software. You can support the development using [Liberapay](https://liberapay.com/mmmikhael/donate), [Patreon](https://www.patreon.com/mmmikhael) or [PayPal](https://paypal.me/mmmikhael/5). Donations helps to find time for resolving non-critical issues and implementing new features.

The more supporters the project gets, the more development time it gets.
And if it doesn't... Well there be updates and new features anyway! Just much less often.

Issues that are scheduled to be fixed in the nearest releases has milestone label attached.

## Credits

* Basic internationalization and German translation for ubports-seabass: [Danfro](https://github.com/Danfro) 
