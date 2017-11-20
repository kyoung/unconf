import json

from django.core.serializers.json import DjangoJSONEncoder
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404

from .models import Pitch, Vote


def index(request):
    pitches = {'pitches': [p.api_fields() for p in Pitch.objects.order_by('created_at')]}
    return HttpResponse(
        json.dumps(pitches, cls=DjangoJSONEncoder),
        content_type='application/json')


def pitch(request):
    pitch_text = request.POST.get('pitch')
    author = request.POST.get('author', '')
    p = Pitch(text=pitch_text, authour=authour)
    p.save()
    return HttpResponse(
        json.dumps(p.api_fields(), cls=DjangoJSONEncoder),
        content_type='application/json' )


def pitch_detail(request, pitch_uuid):
    pitch = get_object_or_404(Pitch, uuid=pitch_uuid)
    return HttpResponse(f'A pitch detail for pitch: {pitch}')


def vote(request):
    sid = request.session.session_key
    return HttpResponse('Some votes!')
