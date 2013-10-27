# JavaScript Assessment - practice

This assessment aims to evaluate your knowledge of JavaScript's basic
and intermediate features.

Topics covered:

  * Basic syntax: function declarations, objects, etc.
  * Closures, `this`, `apply`
  * Prototypal inheritance
  * Module pattern

You have 1 hour. The specs live in the `spec/` directory. Your code
should go in the `src/` directory in the files provided. All your
functions should be namespaced under `Assessment`.

How to run the specs: open up `SpecRunner.html` in a browser.

## Basic JavaScript

### `mergeSort`

### `recursiveExponent`

### `powCall`

## Closures + `this`

### `myCall`

### `transpose`

## Prototypal Inheritance

### `inherits`

Write a function `inherits` that takes two constructor functions (child
and parent) and properly sets up the prototype chain. The function
should return the child constructor. Your function should not call the
parent's constructor function in setting up the prototype chain.

## Module Pattern

### `WakeboardGame`

For this portion of the assessment, do not put anything in your
`Assessment` namespace. Use the `wakeboard_game.js` file.

In this file, set up the following in a single global namespace called
`WakeboardGame`. No portion of the module should be in the global
namespace; everything should be under `WakeboardGame`.

* `WakeboardGame.Boat`

  * Boat constructor that takes a sponsor and sets the boats's sponsor
  * The following methods on the prototype. Each method should simply
    return the name of the method as a string (i.e. `power` should
    return "power" - you can simply hardcode this).

      * `power`
      * `turn`
      * `sink`

* `WakeboardGame.Wakeboarder`

  * Constructor that takes a name and sponsor sets the wakeboarder's name and sponsor
  * Following methods that return the stringified function name:

      * `jump`
      * `spin`
      * `grind`
      * `crash`







