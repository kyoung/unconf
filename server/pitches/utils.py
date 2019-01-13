from collections import defaultdict

from django.core.cache import cache
from django.db.models import Count

from .models import Pitch, Vote, Schedule, Slot, Room, Flag


class SpeakerCollisionBuffer:

    def __init__(self, pitches):
        """
        Takes a Pitch QuerySet Iterator, and helps fetch a next-most
        voted talk while avoiding a speaker collision.
        """
        self._pitches = pitches
        self._collision_tracker = defaultdict(list)
        self._buffered_pitches = []

    def _is_already_speaking(self, speaker, slot):
        return speaker in self._collision_tracker[str(slot)]

    def get_next(self, slot):
        # drain any buffered pitches
        if ( self._buffered_pitches and not 
             self._is_already_speaking(self._buffered_pitches[0].author, slot)):
            talk = self._buffered_pitches[0]
            self._buffered_pitches = self._buffered_pitches[1:]
            return talk

        # pull next pitch from original iterator
        while True:
            talk = next(self._pitches, None)

            # exhausted the iterator
            if not talk:
                return None

            # exit early if no author... can't be helped
            if not talk.author:
                return talk

            # check if already speaking
            if talk.author and self._is_already_speaking(talk.author, slot):
                self._buffered_pitches.append(talk)
                continue

            # record the speaker
            self._collision_tracker[str(slot)].append(talk.author)

            return talk


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
    pitch_collision_buffer = SpeakerCollisionBuffer(pitches)
    for room in rooms:
        for slot in slots:
            pitch = pitch_collision_buffer.get_next(slot)
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
    Flag.objects.delete()
    mode_flag = Flag(name='Allow Pitches', enabled=True)
    mode_flag.save()
    sort_flag = Flag(name='Sort Pitches Date Descending', enabled=False)
    sort_flag.save()


def get_mode():
    cache_mode = cache.get('mode', None)
    if cache_mode:
        return cache_mode

    try:
        flag = Flag.objects.get(name='Allow Pitches')
        mode = 'Pitching' if flag.enabled else 'Schedule'
    except Flag.DoesNotExist:
        heal_flags()
        mode = 'Pitching'
    
    cache.set('mode', mode)
    return mode


def get_order_value():
    cache_order_key = cache.get('order_key', None)
    if cache_order_key:
        return cache_order_key

    try:
        flag = Flag.objects.get(name='Sort Pitches Date Descending')
        order_key = '-created_at' if flag.enabled else 'created_at'
    except Flag.DoesNotExist:
        heal_flags()
        order_key = 'created_at'

    cache.set('order_key', order_key)
    return order_key