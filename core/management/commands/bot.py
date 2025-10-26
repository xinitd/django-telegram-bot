from django.core.management.base import BaseCommand
from core.bot import bot


class Command(BaseCommand):
    help = 'Runs the bot in polling mode. This method continuously polls the Telegram API for new updates.'

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.SUCCESS('Bot successfully started...'))

        bot.enable_save_next_step_handlers(delay=2)
        bot.load_next_step_handlers()
        bot.delete_webhook()
        bot.polling(none_stop=True)
