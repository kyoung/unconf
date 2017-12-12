from django.contrib import admin

# Register your models here.
from .models import Pitch, Vote, Room


class PitchAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {'fields': ['text']}),
        ('Details', {'fields': ['created_at', 'author', 'uuid']}),
    ]


admin.site.register(Pitch, PitchAdmin)
admin.site.register(Vote)
admin.site.register(Room)
