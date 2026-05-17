![Telegram logo](assets/telegram.png)

## Telegram bot with Webhooks

**Deploy a Django + Telegram bot to production in one command** - with webhooks, Docker, PostgreSQL, Nginx and Let's Encrypt SSL.

![Python](https://img.shields.io/badge/python-3.10--3.13-3776AB?style=flat-square&logo=python&logoColor=white)
![Django](https://img.shields.io/badge/django-5.2_LTS-092E20?style=flat-square&logo=django&logoColor=white)
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

- Python 3.10 – 3.13
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

## PRODUCTION

Deploy the bot to a VPS with **Docker, PostgreSQL, Nginx and a free Let's Encrypt SSL certificate** - all configured automatically by a single shell script. Telegram requires HTTPS for webhooks, so SSL is not optional; the included `install.sh` handles certificate issuance and renewal for you.

### Prerequisites

- A VPS with a clean OS - Ubuntu 22.04 LTS is tested and recommended.
- A domain name with an `A` record pointing to your server's public IP (e.g. `bot.yourdomain.com → 1.2.3.4`). DNS must propagate before running the installer.
- Root or `sudo` access on the server.

### 1. Clone the repository

```bash
git clone https://github.com/xinitd/django-telegram-bot.git
cd django-telegram-bot
```

### 2. Configure environment variables

```bash
cp .env.template .env
nano .env
```

Fill in every variable:

- `DOMAIN_NAME` - your full domain, e.g. `bot.yourdomain.com`
- `ADMIN_EMAIL` - used by Let's Encrypt for certificate expiration warnings
- `SECRET_KEY` - Django secret key (generate with `python3 -c "import secrets; print(secrets.token_urlsafe(50))"`)
- `TELEGRAM_TOKEN` - bot token from [@BotFather](https://t.me/BotFather)
- `DEBUG=False` - **must be `False` in production**

### 3. Run the installer

```bash
chmod +x install.sh
sudo ./install.sh
```

The script installs Docker, brings up the `backend`, `db` and `nginx` containers, and issues an SSL certificate via Let's Encrypt.

### 4. Initialize the Django backend

```bash
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
docker compose exec backend python manage.py collectstatic --no-input
```

### 5. Register the Telegram webhook

1. Open `https://your-domain.com/admin/` and log in with the superuser you just created.
2. Go to **Sites** in the admin sidebar.
3. Click `example.com`, change the **Domain name** field to your real domain (e.g. `bot.yourdomain.com`), and save.
4. Return to the Sites list, tick the checkbox next to your site, choose **Set Telegram webhook** from the *Action* dropdown and click **Go**.
5. *(Optional)* Run **Get webhook info** from the same dropdown to verify Telegram is sending updates to your server.

Send `/start` to your bot - you should get an instant reply, this time over webhooks instead of polling.

---

## Related projects

- **[Hypoxia](https://github.com/xinitd/hypoxia)** - forensic CLI for safe data collection from compromised or failing systems. SHA-256 manifests, chain-of-custody logging, checkpoint/resume.
- **[args.tech](https://args.tech)** - my personal blog with hands-on DevOps, Python and Linux tutorials.

## License

Released under the [MIT License](LICENSE).

---

Built by **[@xinitd](https://github.com/xinitd)** · Astana, Kazakhstan

If this template saved you a few hours - a ⭐ on GitHub means a lot.
