![build](https://github.com/milikhin/seabass2/workflows/build/badge.svg)
[![Test coverage](https://api.codeclimate.com/v1/badges/83fe45078487708c6061/test_coverage)](https://codeclimate.com/github/milikhin/seabass2/test_coverage)

# Seabass
## About

Seabass is a code editor for mobile devices.

Supported platforms:

* Ubuntu Touch (hasn't yet been migrated to the Codemirror, [current Ace-based version is here](https://github.com/milikhin/seabass2/tree/ubports-legacy))
* Sailfish OS

[![OpenStore](https://open-store.io/badges/en_US.png)](https://open-store.io/app/seabass2.mikhael)

![Seabass on Ubuntu Touch](https://github.com/milikhin/milikhin.github.io/raw/master/img/seabass/seabass-desktop.png)

## Features

Core features:
* Syntax highlighting for over 100 programming/markup languages
* Navigation buttons
* Light and dark themes
* Reading indentation preferences from .editorconfig files

Ubuntu Touch:
* Adaptive layout and multiple tabs
* Create/Rename/Delete files
* File tree
* Create and build QML, C++, Python and HTML projects using [Clickable](https://gitlab.com/clickable/clickable)

## Build instructions

### Requirements:

* Node.js (any recent version should work)
* pipenv (optional, to run tests for python modules)
* Sailfish SDK (for Sailfish OS)
* clickable (for Ubuntu Touch)

### Ubuntu Touch

Current version from the store is available in the [ubports-legacy branch](https://github.com/milikhin/seabass2/tree/ubports-legacy).

Run `clickable` (in the project root directory).

### Sailfish OS

1. `git submodule update --init`
1. Build editor engine
   1. Install editor dependencies and build tools: `npm ci`
   1. Build editor engine and copy required files to the build directory: `npm run build -- --config-name=sfos`
1. Build App
   * Build `harbour-seabass` using Sailfish SDK

### Running tests:

1. Editor: `npm test`
1. Python modules:  
   1. `cd generic/py-backend`
   1. `pipenv install -d`
   1. `pipenv run pytest **/*.py`
1. Ubuntu Touch app:
   * QML: `clickable test`

## Contribution

Bug reports and feature requests are very appreciated, as so pull requests!
Please see [wiki](https://github.com/milikhin/seabass2/wiki) for project docs. Unit tests for [editor](https://github.com/milikhin/seabass2/tree/master/editor/__tests__),
[python modules](https://github.com/milikhin/seabass2/tree/master/generic/py-backend/tests) and
[ubports-seabass](https://github.com/milikhin/seabass2/tree/master/ubports-seabass/tests) might also be useful.
