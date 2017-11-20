SHELL := /bin/bash

.PHONY: client
client:
	pushd client; elm-make src/Main.elm --output=../server/pitches/static/main.js
