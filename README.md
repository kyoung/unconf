# unconf
A simple application that let's you run an unconference voting scheme without
a wall of stickies and sharpies... as much fun as that is and as much as I love
it.

Once installed, you can read the [manual for operation here](MANUAL.md).

## Setup
### Requirements
You will need Python 3.6 to run the server and a Node Environment with Elm 0.19.0 to run the front-end.

### The Server
`make local` should configure your Python virtual environment in `venv` and
install the required packages, as well as download the Elm packages required.

**NB. A local SQLLite database will be created for local dev.**

Once started you will want to  initialize flags and configure a superuser for
Django administration:
```
> source venv/bin/activate
> cd server
> python manage.py loaddata
> python manage.py createsuperuser
```

`make run` should take care of starting a local dev server on port 8080.

### The Client
`make client` will compile the Elm source and move the result into the
appropriate static asset folder for the server. You'll likely end up doing this
often during development.

If you're running a Node environment, you can run `npm run elm-make` instead.

### Front-end Only Local Development
With a Node environment you can run the entire project without Python. This is
useful for working on Elm or CSS independently and uses
[json-server](https://github.com/typicode/json-server) to mock the database.

1. run `npm install` in your CLI to install Elm and JSON server
1. Duplicate the sample dataset with `cp ./json-server/db.sample.json ./json-server/db.json`
1. run `npm run pitching` or `npm run schedule` and navigate to `localhost:3000`

#### JSON Server
JSON Server mocks the SQLLite DB Python interacts with. You can add and remove
any resources you'd like to create whatever state you'd like. In addition,
`POST` and `DELETE` from the Elm app work as expected. It's _just_ like the
real DB.

#### JSON Server: Modes
There are two distinct modes in Unconf: **Pitching** and **Schedule**. In
Pitching you'll see all the available pitches and votes, whereas Schedule
arranges the pitches into a schedule.

To select a mode, run either `npm run pitching` or `npm run schedule`.

#### JSON Server: Pitches
You can add and remove any pitches in `.json-server/db.json`. Pitches require
a JSON object in the following structure:

```javascript
{
  "text": "JavaScript State of the Union",        // The Title of the Pitch
  "uuid": "a097c86f-bb8d-4c64-8c6a-edd5e90b157d", // Its UUID
  "order": 1,                                     // The sort order
  "votes": 0,                                     // Total number of votes
  "author": "Chris"                               // Author name
},
```

Pitches are RESTful so `/pitches/a097c86f-bb8d-4c64-8c6a-edd5e90b157d` will
return the single pitch. (There's no Elm view, so you'll get a JSON page.)

Instead of deleting pitches, you can easily _hide_ them from the app by:

1. Opening `./json-server/routes-pitching.json`
1. Changing `"/pitches": "/db",` to `"/pitches": "/",`, which will cause the
JSON decoder to _fail_, effectively hiding all the pitches.

#### JSON Server: Votes
`current_user` votes are stored as an array of UUIDs mapping to pitches. To
add or remove _selected voting status_ from a pitch, add or delete the
corresponding UUID in `./json-server/db.json`.

JSON Server requires RESTful APIs with a ID to be passed through the resource
for POST and DELETE to work by default. The Votes table isn't set up like that,
so there is middleware at `./json-server/voting-delete.js` and
`./json-server/voting-post.js` which intercepts the request and modifies the
database accordingly.

#### JSON Server: Slots
When in Schedule mode, the app shows slots instead of pitches. You can add or
remove any slots in `./json-server/db.json`. They require a JSON object like:

```javascript
{
  "time": "10:30",                                // 12-hour time which sets the grouping order
  "room": "c300",                                 // Room to display
  "text": "JavaScript State of the Union",        // Pitch title
  "uuid": "a097c86f-bb8d-4c64-8c6a-edd5e90b157d", // Pitch UUID
  "author": "Chris"                               // Pitch Author
},
```

Slots are RESTful so `/slots/a097c86f-bb8d-4c64-8c6a-edd5e90b157d` will
return the single slot. (There's no Elm view, so you'll get a JSON page.)

Instead of deleting pitches, you can easily _hide_ them from the app by:

1. Opening `./json-server/routes-schedule.json`
1. Changing `"/pitches/schedule": "/db"` to `"/pitches/schedule": "/`, which
will cause the JSON decoder to _fail_, effectively hiding the schedule.

## Production
unconf is currently configured to run on Heroku (if there's interest, I'll
throw a Docker build in as well). It can be deployed as is to a heroku git
endpoint, though you will have to run the `python manage.py` commands
`migrate`, `loaddata`, and `createsuperuser` to get the DB configured.

**If you modify the client code, be sure to also run a `make client` to ensure
that the modified client is compiled before you commit and push to heroku.**

During our run with a ~400 attendee count, autoscaling nodes were able to
handle the traffic at a peak of 3 x1 dynos, (though obviously warming up the dynos
will help). You can probably get away with the free tier version of Heroku's
offereing for similar or smaller events.

**NB. Also consider spinning up a second free-tier version of the application
and substitution the main app's DB string in, to use for administrative purposes
like entering the pitches. This will save you any lag in input flow in the event
that your attendees flood the main web nodes.**


### Environment Variables
#### SECRET_KEY
Django does some pretty nice security things for you out of the box, but you
really ought to set this to help it do that. A long random string will do.

#### DEBUG
Please set to `False` in production.

#### HOSTNAME
Django only allows a select list of hostnames. Set this to lock it down to
exactly your app's name, or to `0.0.0.0` to allow any hostnames.

#### DATABASE_URL
This should be set automatically by Heroku when Postgres is added. Leave it
empty for local dev to get Djano to use a local SQLite3.

#### COLLAPSE_SEPARATOR
If you don't fancy the `-` string that appears between two pitches when they
are collapsed together, you may set this envvar to a string of your choice.

I leave newline escaping as an exercise for the reader.

## About the Security Model
unconf is designed to replace sticky notes and dots with a sharpie marker. As
such the application is not especially security conscious, and rather errs on
the side of intuitive and easy to use for the audience.

Given the nature of developers, it might be helpful to remove the temptation of
attendees to prove how clever they in their ability to "beat" the app by simply
explaining to all attendees exactly how to "cheat" and vote multiple times:
_Clear your cookies_. Now that no one has anything to prove by "hacking" the
app, you should be free to continue your event in peace.


## Screenshots

### Pitches
As pitches are made, an organizer inputs the pitch into the administrative
portal. As they are saved the client polls for new pitches and they begin to
appear on the screen.

![Empty state](screenshots/no_pitches.png)

___

### Voting
As an attendee votes, their selections are marked by their yellow voting dot and
a yellow bar on the top of the pitch. Tapping on a pitch will unvote the topic.

![Crowd votes](screenshots/all_votes.png)

As other members vote, the relative popularity of pitches becomes apparent as
indicated by blue dots across the pitch card.

___

### Schedule View
Once all the voting is done, the administrator generates a schedule
(algorithmically sorted to alot large rooms to popular talks) and switches a
flag in the admin portal to schedule view.

The lineup is displayed, along with a venue map.

![schedule](screenshots/schedule.png)
