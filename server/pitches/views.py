import json

from django.contrib.admin.views.decorators import staff_member_required
from django.core.serializers.json import DjangoJSONEncoder
from django.db.utils import IntegrityError
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404
from django.views.decorators.csrf import csrf_exempt

from .models import Pitch, Vote, Schedule, Slot
from .utils import reschedule


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


def toggle_vote(pitch_uuid, client_id):
    '''
    Create a vote is one doesn't exist for this client, or remove it if it does
    '''
    pitch = Pitch.objects.get(uuid=pitch_uuid)
    v = Vote.objects.all().filter(pitch_id=pitch, client_id=client_id)
    if v.exists():
        v.delete()
    else:
        new_vote = Vote(client_id=client_id, pitch_id=pitch)
        new_vote.save()


@csrf_exempt
def vote(request):
    sid = request.session.session_key

    if request.method == 'POST':
        payload = json.loads(request.body)
        uuid = payload.get('pitch_uuid')
        toggle_vote(uuid, sid)

    votes = Vote.objects.filter(client_id=sid)
    votes_ids = [v.pitch_id.uuid for v in votes]
    response = {"votes": votes_ids}
    return HttpResponse(
        json.dumps(response, cls=DjangoJSONEncoder),
        content_type='application/json')


@staff_member_required
def set_schedule(request):
    '''
    Display a list of the current schedule; allow a POST to trigger a "reflow"
    of the schedule algorithm.

    End users will see the schedule displayed in the client app at / once
    voting closes and the 'Display Schedule' flag is set.
    '''

    if request.method == 'POST':
        reschedule()

    ctx = {"slots": Slot.objects.all().order_by('start_time')}
    return render(request, 'pitches/templates/schedule_admin.html.tmpl', ctx)
