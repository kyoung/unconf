from django.contrib import admin

# Register your models here.
from .models import Pitch, Vote, Room, Slot, Schedule, Flag


class PitchAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {'fields': ['text']}),
        ('Details', {'fields': ['created_at', 'author', 'uuid']}),
    ]


admin.site.register(Pitch, PitchAdmin)
admin.site.register(Vote)
admin.site.register(Slot)
admin.site.register(Room)
admin.site.register(Schedule)
admin.site.register(Flag)
