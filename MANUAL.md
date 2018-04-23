# A manual for unconf

Unconf is designed for unconference / openspaces style pitching and voting, as
well room and schedule management, as an improvement over sticky notes and
sharpie markers. In order to use it you'll need to install on heroku (or a
deployment option of your choice), initialize it as described in the
[README](README.md), and configure it, as described here.

Using the superuser you created during configuration, log into the
administrative portal at `/admin`.

## Rooms
Before the event, head over to `/admin/pitches/room/` and create an instance
for every room in the venue you intend to use. Input a room number as it will
appear on the venue map, and an estimated room capacity.

_The capacities are used to relatively size the spaces available, and don't have
to be exact. If you feel like it, you could simple input `1` for small spaces
and `5` for big ones, with intermediate spaces ranked between._

## Slots
Time slots are input next, at `/admin/pitches/slot/`. Enter as many time slots
as you like, with a start time and end time, in 24hr format.

## Map
_documentation pending once this is implemented__

## Pitches (aka the performative part)
The intended flow is to transcribe the pitches as they are made and input them
into the portal at `/admin/pitches/pitch/`. There is a field for "author"
included, as the original intention was to have twitter handles or the like,
but the field isn't mandatory, and hasn't proved to be necessary.

As speakers complete their pitch, click `Save and add another` and begin
entering the next speaker's pitch.

_NB. Please see the note in the [README](README.md) around setting up a
dedicated admin application. Having voters slamming the application as you're
trying to input pitches can slow down your input rate to the point where you
end up having to copy down pitch text in a notepad while you wait. This is a
bad experience for everyone and will not delight your attendees._

### Collapsing pitches
Often it can be helpful to combine two or more more talks together. To do so,
simply select the two pitches, and then under the `Actions` drop down, select
"Collapse Pitches". This will intelligently combine the set of votes, and
concatenate the two pitches.

_documentation pending on customizing the concatenation string_

## Setting the schedule
As voting gets underway, you may like to begin planning the schedule. To do so
head to `/pitches/set_schedule/`. To populate an new schedule based on the
current state of pitches, rooms, and slots, click `Reshuffle the schedule`.

unconf will attempt to create a schedule that ensures that the most popular
pitches are selected, and that talks are assigned to the most appropriate rooms
based on amount of interest.

Reshuffle the schedule as often as you like as voting continues, and when you
are ready to lock it in, simply switch into schdule mode (see below).

### Overriding the schedule
It may happen that you don't want exactly what the scheduler has planned,
perhaps to better ensure that thematically related talks don't overlap.

To override the scheduler, simply go to `/admin/pitches/schedule/` and edit the
slots and rooms of the talks you wish to move. This isn't exactly a great UX,
and is only recommended to override a small number of scheduler choices.

## Switching into schedule mode
Once you'd like to close off voting and share the schedule with the audience,
you can disable voting by setting the `Allow Pitches` flag to `False`.

Do this at `/admin/pitches/flag/`. __Don't delete the flag, just set it to
False.__
