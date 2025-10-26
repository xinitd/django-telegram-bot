from django.contrib import admin
from django.contrib import admin, messages
from django.contrib.sites.models import Site
from telebot import apihelper
from .bot import bot


admin.site.unregister(Site)
@admin.register(Site)
class CustomSiteAdmin(admin.ModelAdmin):
    list_display = ('domain', 'name')
    search_fields = ('domain', 'name')

    def set_telegram_webhook(self, request, queryset):
        if queryset.count() > 1:
            self.message_user(request, 'Please, select only one site.', messages.WARNING)
            return

        site = queryset.first()
        try:
            webhook_url = f'https://{site.domain}'
            bot.remove_webhook()
            bot.set_webhook(url=webhook_url, drop_pending_updates=True)
            self.message_user(request, f'Webhook was successfully set to: {webhook_url}', messages.SUCCESS)
        except Exception as e:
            self.message_user(request, f'Error setting webhook: {e}', messages.ERROR)

    def get_telegram_webhook_info(self, request, queryset):
        try:
            info = bot.get_webhook_info()
            message = (
                f'URL: {info.url}\n'
                f'Pending updates: {info.pending_update_count}\n'
                f'Last error message: {info.last_error_message or "None"}'
            )
            self.message_user(request, message, messages.INFO, extra_tags='safe pre-wrap')
        except apihelper.ApiTelegramException as e:
            self.message_user(request, f'Telegram API error: {e}', messages.ERROR)

    set_telegram_webhook.short_description = 'Set Telegram webhook'
    get_telegram_webhook_info.short_description = 'Get webhook info'

    actions = [set_telegram_webhook, get_telegram_webhook_info]
