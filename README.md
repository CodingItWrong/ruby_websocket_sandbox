# ruby_websocket_sandbox

A sandbox for building out a high-productivity approach to standard WebSockets in Ruby.

Includes an abstract `ConnectionHandler` that can be adapted to multiple Ruby WebSocket implementations, or even other kinds of messaging.

Includes two implementations:

- `faye-websocket` running on `puma`
- `async-websocket` running on `falcon`

## Requirements

- Ruby
- Postgres, including PG command line tools

## Setup

```bash
$ createdb ruby_websocket_sandbox_development
$ ruby migrations/00001_create_messages_table.rb
```

## Running

```bash
$ bin/falcon
```

or

```bash
$ bin/puma
```

## Trying It Out

```bash
$ npm install -g wscat
$ wscat -c localhost:3000
```

Note that with `async/falcon` the message needs to be valid JSON, so you need to wrap strings in quotes. With `faye/puma` the message is treated as a string, so no special handling is needed.
