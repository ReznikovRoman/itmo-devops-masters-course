from rest_framework.viewsets import ModelViewSet
from rest_framework import serializers

from .models import Movie


class MovieSerializer(serializers.ModelSerializer):
    class Meta:
        model = Movie
        fields = ["id", "title", "rating"]
        extra_kwargs = {
            "rating": {
                "error_messages": {
                    "min_value": "Минимальное %(limit_value)s?",
                    "max_value": "Максимальное %(limit_value)s?",
                },
            },
        }


class MovieViewSet(ModelViewSet):
    queryset = Movie.objects.all()
    serializer_class = MovieSerializer
