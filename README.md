# base16-builder-elixir
This is a base16 builder written in Elixir as defined by the [base16 builder guidelines](https://github.com/chriskempson/base16/blob/39d01a0248c7b28863ebafca66d7e1f5ca867b13/builder.md) version 0.9.0


## Usage Requirements
* [Erlang](http://erlang.org).

## Development Requirements
* [Elixir](https://elixir-lang.org) 1.5.0+.

To acquire dependencies, run:

```bash
mix deps.get
```

## Usage
```bash
base16_builder

Acquires git repositories containing templates and schemes to build base16
themes as defined in the builder guidelines:
https://github.com/chriskempson/base16/blob/master/builder.md


Usage:
./base16_builder           # Runs the build command.
./base16_builder build     # Builds Base16 themes, runs update if required repositories don't exist.
./base16_builder update    # Re-acquires git repositories or creates them if they don't exist.
./base16_builder help      # Prints this help message.
```
