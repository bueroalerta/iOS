# -*- coding: utf-8 -*-
# Generated by Django 1.9.1 on 2016-03-09 07:12
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0105_merge'),
    ]

    operations = [
        migrations.AddField(
            model_name='timeslot',
            name='suspended',
            field=models.BooleanField(default=False),
        ),
    ]
