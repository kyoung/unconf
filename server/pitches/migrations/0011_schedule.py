# Generated by Django 2.0 on 2017-12-17 06:18

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('pitches', '0010_slot'),
    ]

    operations = [
        migrations.CreateModel(
            name='Schedule',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('pitch', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='pitches.Pitch')),
                ('room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='pitches.Room')),
                ('slot', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='pitches.Slot')),
            ],
        ),
    ]
