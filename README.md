# Loaded Questions

This is a work in progress... There is leftover code everywhere with no tests.

## Demo

You can play with it at: https://lq.nicklas.cloud/

## How does it work

This is meant to be played in tandem with the actual board game, ideally with
all players in person.

- There is no authentication and anyone can join your game if they know the
  link to the game
- You must supply your own questions, it is meant to be played in tandem with
  the real game
- There are no time limits, the active player controls the board and can decide
  to end the round whenever he or she wants
- Any player in the game can start a new round

## Why

My family enjoys party games one of which is Loaded Questions. Unfortunately,
having to deal with writing down answers, collecting them, reading them off,
and then attempting to match them in a large party can be quite difficult.

This is meant to facilitate the in-person game and not not meant for remote
play. It can be played remotely but I wouldn't recommend it unless there was a
direct line of communication between all the players and there was a source of
questions.


## How to setup

Requirements:

- [Docker](https://docs.docker.com/get-docker)
- [Docker Compose](https://docs.docker.com/compose/install)

First you will want to build the image:

```console
$ docker-compose build loaded_questions
```

Then you will want to generate a new credentials file and master key:

```console
$ rm config/credentials.yml.enc
$ docker-compose run --rm loaded_questions bin/rails credentials:edit
```

Once you have this set up you will want to create the database:

```console
$ docker-compose run --rm loaded_questions bin/rails db:setup
```

Finally you will launch all of the services into the background:

```console
$ docker-compose up
```

Then navigate to http://localhost:3000.
