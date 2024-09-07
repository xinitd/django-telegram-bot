<div align="center">

  <img src="images/telegram.png" alt="Telegram logo">

  <h2>Telegram bot with Webhooks</h2>

  <p>
    <a href="#development">Development</a>
    ·
    <a href="#deployment-production-usage-with-webhooks-in-debian-based-distros">Deployment in Debian</a>
    ·
    <a href="#docker-deployment">Docker deployment</a>
  </p>
</div>

<div align="center">
  <h2>About</h2>
</div>

Telegram bot builded on Django web-framework, using [pyTelegramBotAPI](https://github.com/eternnoir/pyTelegramBotAPI.git) library.

Why Django? Its very customizable. Here Django used for setting Webhooks, but also may be extended for storing any data in database and interaction with user.

Body of bot located in `core/bot.py`. First function need for handle `/start` command from user. Second function just quote and repeat all user sended messages.

File `core/views.py` contain two views. First view needed for setting Webhooks to Telegram's server. Second view get updates from Telegram's server.

<div align="center">
  <h2>Development</h2>
</div>

- Install dependencies: `sudo apt install python3 python3-pip python3-venv git -y`

- Clone repo: `git clone https://github.com/xinitd/django-telegram-bot.git`

- Enter in project directory: `cd django-telegram-bot`

- Create virtual environment: `python -m venv env`

- Activate virtual environment: `source env/bin/activate`

- Install requirements: `pip install django djangorestframework gunicorn pyTelegramBotAPI pyyaml` or `pip install -r requirements.txt`

- Create settings from template: `cp backend/settings.template.yaml backend/settings.yaml`

- Generate django secret key and insert in `backend/settings.yaml`

- Get token from [@BotFather](https://t.me/BotFather) and insert in `backend/settings.yaml` file (TELEGRAM_TOKEN) section

- Enter your domain name in `backend/settings.yaml` (WEBHOOK_HOST)

- Uncomment `# bot.infinity_polling()` line in `core/bot.py` file

- Run bot for testing: `python -m core.bot`

- Send `/start` message to your bot

<div align="center">
  <h2>Deployment (production usage) with Webhooks in Debian based distros</h2>
</div>

- Install dependencies: `sudo apt install python3 python3-pip python3-venv nginx certbot python3-certbot-nginx git -y`

- Clone repo: `git clone https://github.com/xinitd/django-telegram-bot.git`

- Enter in project directory: `cd django-telegram-bot`

- Create virtual environment: `python -m venv env`

- Activate virtual environment: `source env/bin/activate`

- Install requirements: `pip install django djangorestframework gunicorn pyTelegramBotAPI pyyaml` or `pip install -r requirements.txt`

- Create settings from template: `cp backend/settings.template.yaml backend/settings.yaml`

- Generate django secret key and insert in `backend/settings.yaml`

- Get token from [@BotFather](https://t.me/BotFather) and insert in `backend/settings.yaml` file (TELEGRAM_TOKEN) section

- Enter your domain name in `backend/settings.yaml` (WEBHOOK_HOST)

- Create socket file `sudo nano /etc/systemd/system/mytelegrambot.socket`:

```
[Unit]
Description=My Telegram bot's socket

[Socket]
ListenStream=/run/mytelegrambot.sock

[Install]
WantedBy=sockets.target
```

- Create service file `sudo nano /etc/systemd/system/mytelegrambot.service`:

```
[Unit]
Description=My Telegram bot's service
Requires=mytelegrambot.socket
After=network.target

[Service]
User=your_user
Group=your_group
WorkingDirectory=/home/your_user/django-telegram-bot
ExecStart=/home/your_user/django-telegram-bot/env/bin/gunicorn \
          --access-logfile - \
          --workers 1 \
          --bind unix:/run/mytelegrambot.sock \
          backend.wsgi:application

[Install]
WantedBy=multi-user.target
```

- Start socket and enable autorun:

```
sudo systemctl start mytelegrambot.socket
sudo systemctl enable mytelegrambot.socket
```

- Start bot's service:

```
sudo systemctl daemon-reload
sudo systemctl restart mytelegrambot.service
sudo systemctl enable mytelegrambot.service
```

- Configure Nginx. Create configuration: `sudo nano /etc/nginx/sites-available/mytelegrambot`

```
server {
    listen 80;
    server_name mytelegrambot.mydomain.com;

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/mytelegrambot.sock;
    }
}
```

- Create symlink for configuration file: `sudo ln -s /etc/nginx/sites-available/mytelegrambot /etc/nginx/sites-enabled`

- Test Nginx configuration for syntax errors: `sudo nginx -t`

- Receive certificate from Letsencrypt certbot `sudo certbot --nginx -d mytelegrambot.mydomain.com`

- Restart Nginx: `sudo systemctl restart nginx`

- Open `mytelegrambot.mydomain.com` url in browser

- Now send `/start` message to your bot

<div align="center">
  <h2>Docker deployment</h2>
</div>

- Install Docker in your OS

- Install Git and Certbot: `sudo apt install git certbot -y`

- Clone repo: `git clone https://github.com/xinitd/django-telegram-bot.git`

- Enter in project directory: `cd django-telegram-bot`

- Create settings from template: `cp backend/settings.template.yaml backend/settings.yaml`

- Generate django secret key and insert in `backend/settings.yaml`

- Get token from [@BotFather](https://t.me/BotFather) and insert in `backend/settings.yaml` file (TELEGRAM_TOKEN) section

- Enter your domain name in `backend/settings.yaml` (WEBHOOK_HOST)

- Edit `nginx/default.conf` file and change `mytelegrambot.mydomain.com` to your domain

- Generate new certificate and key for your domain: `sudo certbot certonly --standalone -d mytelegrambot.mydomain.com`

- Copy certificate and key in `nginx/` path: `sudo cp /etc/letsencrypt/live/mytelegrambot.mydomain.com/fullchain.pem /etc/letsencrypt/live/mytelegrambot.mydomain.com/privkey.pem nginx/`

- Run: `docker compose up -d`
