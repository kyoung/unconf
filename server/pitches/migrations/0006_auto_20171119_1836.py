# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-11-20 02:36
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('pitches', '0005_auto_20171119_1744'),
    ]

    operations = [
        migrations.RenameField(
            model_name='pitch',
            old_name='authour',
            new_name='author',
        ),
    ]
