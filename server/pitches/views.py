import json

from django.views.decorators.csrf import csrf_exempt
from django.core.serializers.json import DjangoJSONEncoder
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404

from .models import Pitch, Vote


def index(request):
    # we order on the server side to spare ourselves the pain of parsing dates
    # in Elm on the client side
    pitches = [
        p.api_fields(order=i)
        for i, p
        in enumerate(Pitch.objects.order_by('created_at'))
    ]
    response = {'pitches': pitches}
    return HttpResponse(
        json.dumps(response, cls=DjangoJSONEncoder),
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


@csrf_exempt
def vote(request):
    sid = request.session.session_key

    if request.method == 'POST':
        payload = json.loads(request.body)
        uuid = payload.get('pitch_uuid')
        pitch = Pitch.objects.get(uuid=uuid)
        new_vote = Vote(client_id=sid, pitch_id=pitch)
        new_vote.save()

    votes = Vote.objects.filter(client_id=sid)
    votes_ids = [v.pitch_id.uuid for v in votes]
    response = {"votes": votes_ids}
    return HttpResponse(
        json.dumps(response, cls=DjangoJSONEncoder),
        content_type='application/json')
