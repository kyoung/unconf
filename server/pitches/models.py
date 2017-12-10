import datetime
import uuid

from django.db import models
from django.utils import timezone


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
        }

    def __str__(self):
        return self.text


class Vote(models.Model):
    client_id = models.CharField(max_length=32)
    pitch_id = models.ForeignKey(Pitch, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.client_id}:{self.pitch_id}'

    class Meta:
        unique_together = (('client_id', 'pitch_id'),)
