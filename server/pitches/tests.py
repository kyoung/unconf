import uuid

from django.test import TestCase

from .models import Pitch, Slot, Room, Vote, Schedule
from .utils import reschedule


def rand_id():
    return uuid.uuid4().hex


class SchedulingTestCases(TestCase):

    def setUp(self):
        Slot.objects.create(start_time='10:00', end_time='11:00')
        Slot.objects.create(start_time='11:00', end_time='12:00')
        Slot.objects.create(start_time='12:00', end_time='13:00')

        Room.objects.create(number='C100', capacity=100)
        Room.objects.create(number='C101', capacity=110)
        Room.objects.create(number='C102', capacity=120)
        
        self.a_talks = 4
        self.a_popularity_bump = 5
        for i in range(self.a_talks):
            p = Pitch.objects.create(text=f'a{i}', author='A')
            for j in range(i+self.a_popularity_bump):
                Vote.objects.create(client_id=rand_id(), pitch_id=p)
        
        self.b_talks = 3
        for i in range(self.b_talks):
            Pitch.objects.create(text=f'a{i}', author='B')
            Vote.objects.create(client_id=rand_id(), pitch_id=p)

        self.c_talks = 5
        for i in range(self.c_talks):
            Pitch.objects.create(text=f'c{i}', author='C')

    def test_reschedule(self):
        reschedule()

        # there are more talks than rooms x slots, so there should be nine bookings
        all_bookings = Schedule.objects.all()
        self.assertEqual(all_bookings.count(), 9)

        # even though all 'a' talks were more voted than 'b' talks, 
        # only the most popular should be picked
        booked_a_talks = Schedule.objects.filter(pitch__author='A')
        self.assertEqual(booked_a_talks.count(), 3)
        for a_talk in booked_a_talks:
            self.assertNotEqual(a_talk.pitch.text, 'a0')

        # all of 'b' talks should have been picked
        booked_b_talks = Schedule.objects.filter(pitch__author='B')
        self.assertEqual(booked_b_talks.count(), 3)

        # 3 of the unpopular 'c' talks should have been picked
        booked_c_talks = Schedule.objects.filter(pitch__author='C')
        self.assertEqual(booked_c_talks.count(), 3)
        