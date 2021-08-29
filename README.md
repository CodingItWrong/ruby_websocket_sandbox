# ruby_websocket_sandbox

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
$ bin/serve
```

## Trying It Out

```bash
$ npm install -g wscat
$ wscat -c localhost:3000
```
