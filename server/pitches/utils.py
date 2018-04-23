from django.core.cache import cache
from django.db.models import Count

from .models import Pitch, Vote, Schedule, Slot, Room, Flag


def reschedule():
    '''
    Ensure that the most popular track don't overlap.

    '''
    Schedule.objects.all().delete()
    pitches = (
        p for p in
        (Pitch
            .objects
            .annotate(vote_count=Count('vote'))
            .order_by('-vote_count')
        )
    )
    slots = Slot.objects.all().order_by('start_time')
    rooms = Room.objects.all().order_by('-capacity')
    for room in rooms:
        for slot in slots:
            pitch = next(pitches, None)
            if not pitch:
                return
            s = Schedule(pitch=pitch, room=room, slot=slot)
            s.save()


def toggle_vote(pitch_uuid, client_id):
    '''
    Create a vote is one doesn't exist for this client, or remove it if it does
    '''
    pitch = Pitch.objects.get(uuid=pitch_uuid)
    v = Vote.objects.all().filter(pitch_id=pitch, client_id=client_id)
    if v.exists():
        v.delete()
    else:
        new_vote = Vote(client_id=client_id, pitch_id=pitch)
        new_vote.save()


def heal_flags():
    '''
    Did you accidentally delete the flag?
    '''
    mode_flag = Flag(name='Allow Pitches', enabled=True)
    mode_flag.save()


def get_mode():
    cache_mode = cache.get('mode', None)
    if cache_mode:
        mode = cache_mode
    else:
        try:
            flag = Flag.objects.get(name='Allow Pitches')
            mode = 'Pitching' if flag.enabled else 'Schedule'
        except Flag.DoesNotExist:
            heal_flags()
            mode = 'Pitching'
        cache.set('mode', mode)
    return mode
