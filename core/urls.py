from django.urls import path
from .views import *

app_name = 'core'

urlpatterns = [
    path('', get_updates, name='get_updates'),
]
