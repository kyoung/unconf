from django.db.models import Count

from .models import Pitch, Vote, Schedule, Slot, Room


def reschedule():
    '''
    Ensure that the most popular track don't overlap.

    '''
    current_shedule = Schedule.objects.all().delete()
    pitches = (
        p for p in
        (Pitch
            .objects
            .annotate(vote_count=Count('vote'))
            .order_by('-vote_count')
        )
    )
    slots = Slot.objects.all().order_by('start_time')
    slot_count = slots.count()
    rooms = Room.objects.all().order_by('-capacity')
    for room in rooms:
        for slot in slots:
            pitch = next(pitches, None)
            if not pitch:
                return
            s = Schedule(pitch=pitch, room=room, slot=slot)
            s.save()
