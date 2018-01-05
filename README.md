# unconf
A simple application that let's you run an unconference voting scheme without
a wall of stickies and sharpies... as much fun as that is and as much as I love
it.

## Setup
### Requirements
You will need Python 3.6 and Elm 0.18.0 to run this project.

`make install` should configure your Python virtual environment in `venv` and
install the required packages, as well as download the Elm packages required.

**NB. A local SQLLite database will be created for local dev.**

Once started you will want to configure a superuser for Django administration:
```
> source venv/bin/activate
> cd server
> python manage.py createsuperuser
```

## Running the server
`make run` should take care of starting a local dev server on port 8080.

## TODO
- [ ] Production DB env var handling
- [ ] Release "Schedule" to client; client side schedule display when voting is
      complete
- [ ] Get a designer to look everything over
