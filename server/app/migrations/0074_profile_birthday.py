# -*- coding: utf-8 -*-
# Generated by Django 1.9.2 on 2016-02-17 07:37
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0073_auto_20160217_1031'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='birthday',
            field=models.DateTimeField(blank=True, default=None, null=True),
        ),
    ]
