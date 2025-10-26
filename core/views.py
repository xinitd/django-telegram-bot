import json
from rest_framework.decorators import api_view
from rest_framework.response import Response
import telebot
from .bot import bot


@api_view(['POST'])
def get_updates(request):
    json_string = json.dumps(request.data)
    update = telebot.types.Update.de_json(json_string)
    bot.process_new_updates([update])
    return Response('')
