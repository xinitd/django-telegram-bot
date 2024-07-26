from backend.settings import settings
import json

from rest_framework.decorators import api_view
from rest_framework.response import Response
from .bot import bot
import telebot


@api_view(['GET'])
def set_webhook(request):
    bot.remove_webhook()
    bot.set_webhook(url='https://' + settings['WEBHOOK_HOST'] + ':443/' + settings['TELEGRAM_TOKEN'])
    return Response('')


@api_view(['POST'])
def get_updates(request):
    json_string = json.dumps(request.data)
    update = telebot.types.Update.de_json(json_string)
    bot.process_new_updates([update])
    return Response('')
