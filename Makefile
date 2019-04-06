SHELL := /bin/bash

.PHONY: client
client:
	node_modules/.bin/elm make client/src/Main.elm --output=server/pitches/static/main.js

.PHONY: local
local:
	python3.6 -m venv venv
	source venv/bin/activate; pip install -r requirements.txt
	source venv/bin/activate; pushd server; python manage.py migrate
	pushd client; elm-package install -y

.PHONY: run
run: client
	source venv/bin/activate; pushd server; python manage.py runserver 0.0.0.0:8080
