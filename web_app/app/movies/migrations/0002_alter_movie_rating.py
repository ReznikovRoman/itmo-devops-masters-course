# Generated by Django 5.1.3 on 2024-11-18 17:31

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='movie',
            name='rating',
            field=models.PositiveSmallIntegerField(validators=[django.core.validators.MinValueValidator(1, message='Минимальное?'), django.core.validators.MaxValueValidator(5, message='Максимальное?')]),
        ),
    ]