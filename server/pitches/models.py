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

    def api_fields(self):
        return {
            'text': self.text,
            'created_at': self.created_at,
            'uuid': self.uuid,
        }

    def __str__(self):
        return self.text


class Vote(models.Model):
    client_id = models.CharField(max_length=32)
    pitch_id = models.ForeignKey(Pitch, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.client_id}:{self.pitch_id}'
