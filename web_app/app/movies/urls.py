from django.urls.conf import include, path
from rest_framework import routers

from .views import MovieViewSet

router = routers.DefaultRouter()
router.register('movies/', MovieViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
