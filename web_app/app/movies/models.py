from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models


class Movie(models.Model):
    title = models.CharField(
        max_length=100,
        unique=True,
        error_messages={
            'unique': 'Уникальное?',
        },
    )
    rating = models.PositiveSmallIntegerField(
        validators=[
            MinValueValidator(1, message='Минимальное?'),
            MaxValueValidator(5, message='Максимальное?')
        ],
        error_messages={
            'min_value': 'Минимальное?',
            'max_value': 'Максимальное?',
        },
    )

    class Meta:
        verbose_name = 'фильм'
        verbose_name_plural = 'фильмы'
