from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^pitch/', views.pitch, name='pitch'),
    url(r'^vote/', views.vote, name='vote'),
    url(r'^(?P<pitch_uuid>[0-9a-z]+)/', views.pitch_detail, name='pitch_detail'),
]
