from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.pitches, name='index'),
    url(r'^pitch/', views.pitch, name='pitch'),
    url(r'^vote/', views.vote, name='vote'),
    url(r'^mode/', views.mode, name='mode'),
    url(r'^schedule/', views.schedule, name='get schedule'),
    url(r'^twitter_schedule/', views.twitter_schedule, name='twitter schedule'),
    url(r'^set_schedule/', views.set_schedule, name='set_schedule'),
    url(r'^(?P<pitch_uuid>[0-9a-z]+)/', views.pitch_detail, name='pitch_detail'),
]
