# README
This is a dummy application where I try anything I'm interested in.

The code for other features are in branches.

These are branches I want you to take a look at:
- `expenses-tracker` features a calendar (made with HTML table) where you can log your expenses.
Dates with expenses are highlighted in the calendar and there is also a breakdown of expenses per month with its total

- `gen-auth` is where I made the authentication system that's currently in `main`. It's a Ruby/Rails version of Elixir Phoenix's `gen.auth` or at least it tries to be.
This is merged in main because almost everything needs an authentication system and I'd like this to be the default for any other stuff I'm trying out.

- `webrtc` is where I'm trying to make something like Google Meet or Zoom. I'm following a [book](https://pragprog.com/titles/ksrtc/programming-webrtc/). The book uses Node and Socket.io but my implementation here uses Ruby and Rails w/ ActionCable.

- `chat-system` is basically a chat system. I'm in the middle of trying to implement read receipts.


## App prerequisites
1. Install Ruby 3.1.0
2. Install Postgres
3. Install Node

When running `chat-system` or `web-rtc` you'll have to install Redis.

## App setup
```bash
./bin/setup
```
This is a idempotent script which automates a lot of setup steps that you need to do:
- Install Ruby dependencies
- Set up `config/application.yml` that you **need to tweak** a little bit for your development environment (check the output as you run this script)
- Recreate the development and test databases
- Clear logs and temp files
- Install JavaScript dependencies


## Running the app
`./bin/dev`

## Running tests
All tests except system tests: `./bin/rails test`

System tests: `./bin/rails test:system`