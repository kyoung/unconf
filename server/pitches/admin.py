from django.contrib import admin

# Register your models here.
from .models import Pitch, Vote, Room, Slot, Schedule, Flag


def collapse_pitches(model_admin, request, pitch_set):
    base_pitch = pitch_set[0]
    for pitch in pitch_set[1:]:
        base_pitch.merge(pitch)
collapse_pitches.short_description = 'Collapse pitches'


class PitchAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {'fields': ['text', 'author']}),
        ('Details', {'fields': ['created_at', 'uuid']}),
    ]
    actions = [collapse_pitches]


def swap_talks(model_admin, request, talk_set):
    if len(talk_set) != 2:
        # Do nothing; undefined behaviour
        return
    talk_set[0].swap(talk_set[1])
swap_talks.short_description = 'Swap talks'


class ScheduleAdmin(admin.ModelAdmin):
    actions = [swap_talks]


admin.site.site_header = 'Unconf Admin'

admin.site.register(Pitch, PitchAdmin)
admin.site.register(Vote)
admin.site.register(Slot)
admin.site.register(Room)
admin.site.register(Schedule, ScheduleAdmin)
admin.site.register(Flag)
