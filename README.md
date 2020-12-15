# Elm Bingo

Elm was never a sexy language to me. To be honest, I found it a bit ugly to look at - from a glance it didn't look appealing so I decided to learn Elixir instead of looking further into Elm and understanding why so many people love it. But I've got around to it now and I'm so glad I did. This repo contains all my notes about Elm as I go through The Pragmatic Studio's [Building Web Apps with Elm](https://pragmaticstudio.com/courses/elm) where I build a game of Bingo while learning core concepts in Elm. 

## Type System

Elm is a statically typed language. That means it has types. All the types! It's highly recommended you use Type Annotations on your functions so the compiler can be as useful as possible but it's not required. These are a few of the data types in Elm with some handy info:

* Float / Int / Number
* String / Char
* Bool
* List `[]`
  * This is usually seen as `List a` where `a` is a standin for a type of value in the List.
  * Lists can only contain the same type.
  * E.g. a List with a string will be `["hey"] = List String`
* Tuples `()`
  * Tuples can contain different types
* Record `{}`
  * A Record is a data type that stores key value pairs.
  * You can store different data types in a record.
  * You can use dot notation to access values of a key or just use a space: `obj.key | obj key`

## Currying

I didn't really understand currying that well before this but I think I've got a better grasp of it now. All Elm functions take in 1 argument and return 1 result. That result can either be a value or another function. All functions in Elm are curried so you don't need to pass all arguments at once.

```elm
String.pad
-- Type annotation
pad : Int -> Char -> String -> String
-- This takes an integer as the first argument, a character as the second, a string as the third and returns a string.

-- Can also be written
pad : Int -> (Char -> (String -> String))
-- This shows it takes an integer as the first argument and returns a function that takes a character as the first argument and so on..
```

### Useful general knowledge

* The result of a piped operation is applied as the last argument.
```
"Bingo!"
    |> String.toUpper
    |> String.repeat 3

Output: "BINGO!BINGO!BINGO!"
```
* Elm doesn't do implicit type conversion. It will never conver an int to a string.
* Elm functions are guaranteed to be stateless. Given the same arguments, a fun will always return the same result.
* You can declare anonymous funs as `\x y -> x + y` and then assign this to use it in your app.
* Everything in Elm is a function. You build HTML markup by calling functions on the `Html` module. You can either expose all functions in a module with `import x exposing (..)` or expose specific functions with `import x exposing (x, y, z)`. You can also create aliases like `import Html as H` so to use this alias as the prefix when calling functions.

### Useful commands

* `elm init` to initalise an Elm application
* `elm-make` to compile elm code to JavaScript to serve
* `elm-live xx.elm --open --output=xx.js` to start a dev server with hot reloading

**Additional params**

* `--warn` to show compiler warnings
* `--debug` to show application state history
