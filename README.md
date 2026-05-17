![Telegram logo](assets/telegram.png)

## Telegram bot with Webhooks

**Deploy a Django + Telegram bot to production in one command** - with webhooks, Docker, PostgreSQL, Nginx and Let's Encrypt SSL.

![Python](https://img.shields.io/badge/python-3.10+-3776AB?style=flat-square&logo=python&logoColor=white)
![Django](https://img.shields.io/badge/django-5.x-092E20?style=flat-square&logo=django&logoColor=white)
![Docker](https://img.shields.io/badge/docker-ready-2496ED?style=flat-square&logo=docker&logoColor=white)
![License](https://img.shields.io/github/license/xinitd/django-telegram-bot?style=flat-square)
![Last commit](https://img.shields.io/github/last-commit/xinitd/django-telegram-bot?style=flat-square&color=green)
![Stars](https://img.shields.io/github/stars/xinitd/django-telegram-bot?style=flat-square)

[About](#about) · [Setup DEV environment](#dev) · [PRODUCTION deployment](#production)

---

## About

**Production-ready Django + Telegram bot template** with webhooks, Docker, PostgreSQL, Nginx and Let's Encrypt SSL. Deploy a fully working bot to a fresh VPS with a single command.

Built on top of Django and [`pyTelegramBotAPI`](https://github.com/eternnoir/pyTelegramBotAPI), this template solves the most painful part of going from a local Telegram bot tutorial to a real deployment - switching from long polling to webhooks, managing SSL certificates, and running the bot behind a reverse proxy.

### Why Django?

Django brings a powerful admin panel and a battle-tested ORM out of the box. Here it's used to:

- register, inspect and delete Telegram webhooks straight from the Django admin (no curl scripts);
- store users, messages and bot state in PostgreSQL;
- extend the bot with custom Django apps, views and APIs as the project grows.

### Features

- **Webhook-first architecture** - no polling, no extra daemons. Telegram updates arrive as standard Django requests.
- **Django Admin integration** - set, inspect and delete the Telegram webhook from a dropdown action.
- **One-command deployment** - `install.sh` provisions Docker, PostgreSQL, Nginx and a Let's Encrypt SSL certificate.
- **Modular handler architecture** - each command lives in its own module and is auto-registered.
- **Production-ready by default** - separate Dockerfile, `.env`-driven config, static via `collectstatic`, HTTPS-only.
- **DEV mode included** - switch to long polling locally with `python manage.py bot` without touching production setup.

## DEV

Run the bot locally in **long polling mode** - no public IP, no SSL, no webhook setup required. Ideal for development, debugging and testing new commands before deploying to production.

### Prerequisites

- Python 3.10+
- Git
- A Telegram bot token - get one from [@BotFather](https://t.me/BotFather) in under a minute.

### 1. Clone the repository

```bash
sudo apt install git python3 python3-venv -y    # Ubuntu / Debian
git clone https://github.com/xinitd/django-telegram-bot.git
cd django-telegram-bot
```

### 2. Set up the Python virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Configure environment variables

```bash
cp .env.template .env
```

Open `.env` and fill in:

- `SECRET_KEY` - any random string (generate with `python -c "import secrets; print(secrets.token_urlsafe(50))"`)
- `TELEGRAM_TOKEN` - the token from @BotFather

Apply database migrations:

```bash
python manage.py migrate
```

### 4. Run the bot

```bash
python manage.py bot
```

Send `/start` to your bot in Telegram - it should reply immediately. If nothing happens, double-check `TELEGRAM_TOKEN` and that the bot is started (not paused) in @BotFather.

---
<div align="center">
  <h2>PRODUCTION</h2>
</div>

This guide provides an automated way to deploy the bot using Docker, PostgreSQL, Nginx, and Let's Encrypt for SSL.

1. Prerequisites:

    - A server (VPS) with a clean OS (e.g., Ubuntu 22.04).

    - A domain name pointing to your server's IP address.

2. Installation:

    - Clone the project:

      ```
      git clone https://github.com/xinitd/django-telegram-bot.git
      cd django-telegram-bot
      ```

    - Create and edit your environment file:

      ```
      cp .env.template .env
      nano .env
      ```

      *Fill in all variables: DOMAIN_NAME, ADMIN_EMAIL, SECRET_KEY, etc. Set DEBUG=False.*

    - Run the installer:

      ```
      chmod +x install.sh
      sudo ./install.sh
      ```

    - Apply database migrations:
    
      ```
      docker compose exec backend python manage.py migrate
      ```

    - Create a superuser:

      ```
      docker compose exec backend python manage.py createsuperuser
      ```

    - Collect static files:

      ```
      docker compose exec backend python manage.py collectstatic --no-input
      ```

 3. Final setup:

    1. Open in browser `https://your-domain.com/admin/` and log in.

    2. Navigate to the **Sites** section.

    3. Click on `example.com`, change the **Domain name** to your actual domain (e.g., `bot.mydomain.com`), and save.

    4. Return to the Sites list, check the box next to your site, and select the **Set Telegram webhook** action from the dropdown. Click "Go".

    5. **(Optional)** Use the **Get webhook info** action to verify that everything is working correctly.
