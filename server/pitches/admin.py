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
        (None, {'fields': ['text']}),
        ('Details', {'fields': ['created_at', 'author', 'uuid']}),
    ]
    actions = [collapse_pitches]




admin.site.register(Pitch, PitchAdmin)
admin.site.register(Vote)
admin.site.register(Slot)
admin.site.register(Room)
admin.site.register(Schedule)
admin.site.register(Flag)
