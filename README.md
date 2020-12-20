# Elm Bingo

Elm was never a sexy language to me. To be honest, I found it a bit ugly to look at - from a glance it didn't look appealing so I decided to learn Elixir instead of looking further into Elm and understanding why so many people love it. But I've got around to it now and I'm so glad I did. This repo contains all my notes about Elm as I go through The Pragmatic Studio's [Building Web Apps with Elm](https://pragmaticstudio.com/courses/elm) where I build a game of Bingo while learning core concepts in Elm. As with my [Elixir Server Readme](https://github.com/zahradeenie/server), this Readme will detail the concepts I've learnt through the course.

## Building blocks of Elm

**Type System**

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

**Currying**

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

**Type Alias and Type Annotations**

Type aliases are useful to create if you want to reference a type annotation in more than one place. What's more is that they also double as named functions. If you aliased a record, this becomes a record constructor where you can create a new record by passing in the arguments it takes in. A type annotation defines the data types that a function expects to receive and return.

```elm
type alias Animal =
    { name : String
    , legs : Int
    , sound : String
    }

-- Type annotation of this will be
Animal : String -> Int -> String
```

## Data Flow

When a user interacts with your application, a message is always produced and sent to the Elm runtime which feeds this into the update function with the current model. The update fun creates a new model with the updated state based on the message that was sent. Th view fun is called with the new model and returns DOM nodes representing HTML which the runtime will render in the browser.

An application's state is stored in the Elm runtime's memory.

## The Elm Architecture

The data flow mentioned above is the pattern known as The ELm Architecture. You have three main components:

1. Model: a record that contains the app's current state
2. Update: updates the state based on the message from a user event and returns a new model
3. View: takes a model and returns DOM nodes to be rendered based on the state

These three components are wired together with the Html.beginnerProgram fun which is called from the main fun. The Elm runtime calls the main fun to kick off the application and co-ordinates the data flow. Everything runs through the runtime.

## Effects and Commands

Elm doesn't allow side effects to take place inside functions so instead it uses commands that are sent to the Elm Runtime which handles all the dirty work so your functions can stay pure. You can define functions that takes a command and returns a message where youc an extract and use the data in the message in your functions. E.g. in the application, there's a function to post the score of the player to the server. It takes in the current model and returns a command message. All the function does is send a Http post request to the API endpoint we have setup in the server and returns a message that we can pattern match against in the update function.

```elm
postScore : Model -> Cmd Msg
postScore model =
    let
        body =
            encodeScore model
                |> Http.jsonBody

        request =
            Http.post postUrl body scoreDecoder
    in
        Http.send NewScore request
```

---

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


### Notes and intsallation

This project was built with Elm 0.18.0 which is referenced in the `.tool-versions` file. To run this locally, you need to use this version.

- Install elm with asdf: `asdf plugin-add elm https://github.com/asdf-community/asdf-elm.git`
- To install the necessary version run `asdf install` in the root directory
- To start the dev server run `elm-live Bingo.elm --open --output=app.js`
- The server that runs the API we call to in the app can be found in `./server`. To set up the API server, run:
  - `cd server && npm install`
  - `node server.js`
