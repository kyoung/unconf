import datetime
import os
import uuid

from django.db import models
from django.utils import timezone


COLLAPSE_SEPARATOR = os.getenv('COLLAPSE_SEPARATOR', '\n-------\n')


def gen_uuid():
    return uuid.uuid4().hex


class Pitch(models.Model):
    text = models.TextField()
    created_at = models.DateTimeField('created at', default=timezone.now)
    author = models.CharField(max_length=64, null=True, blank=True)
    uuid = models.CharField(max_length=32, default=gen_uuid)

    def api_fields(self, order=0):
        # It is easier to explicity order the items in the set server-side
        # when generating a list of pitches;
        # parsing dates in Elm on the client is a feat of a Kafkesque nature
        return {
            'text': self.text,
            'order': order,
            'uuid': self.uuid,
            'votes': self.vote_set.count(),
            'author': self.author,
        }

    def merge(self, other):
        self.text += f'{COLLAPSE_SEPARATOR}{other.text}'
        self.save()
        self_client_votes = [v.client_id for v in self.vote_set.iterator()]
        other_client_votes = [v.client_id for v in other.vote_set.iterator()]
        self.vote_set.all().delete()
        for client_id in set(self_client_votes + other_client_votes):
            v = Vote(client_id=client_id, pitch_id=self)
            v.save()
        other.delete()

    def __str__(self):
        return self.text


class Vote(models.Model):
    client_id = models.CharField(max_length=32)
    pitch_id = models.ForeignKey(Pitch, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.client_id}:{self.pitch_id}'

    class Meta:
        unique_together = (('client_id', 'pitch_id'),)


class Room(models.Model):
    number = models.CharField(max_length=16)
    capacity = models.IntegerField()

    def __str__(self):
        return f'{self.number} (capacity {self.capacity})'


class Slot(models.Model):
    start_time = models.TimeField()
    end_time = models.TimeField()

    def __str__(self):
        return f'{self.start_time} - {self.end_time}'


class Schedule(models.Model):
    pitch = models.ForeignKey(Pitch, on_delete=models.CASCADE)
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    slot = models.ForeignKey(Slot, on_delete=models.CASCADE)

    def api_fields(self):
        return {
            'text': self.pitch.text,
            'room': self.room.number,
            'time': self.slot.start_time,
            'uuid': self.pitch.uuid,
            'author': self.pitch.author,
        }

    def swap(self, other):
        '''
        Given two talks, swap their time/location...
        '''
        self.pitch, other.pitch = other.pitch, self.pitch
        self.save()
        other.save()

    def __str__(self):
        return f'Room: {self.room} ({self.slot}): {self.pitch} - {self.pitch.author}'


class Flag(models.Model):
    name = models.CharField(max_length=32)
    enabled = models.BooleanField()

    def __str__(self):
        return f'{self.name}: {self.enabled}'
