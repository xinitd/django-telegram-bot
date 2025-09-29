<div align="center">

  <img src="images/telegram.png" alt="Telegram logo">

  <h2>Telegram bot with Webhooks</h2>

  <p>
    <a href="#about">About project</a>
    ·
    <a href="#dev">Setup DEV environment</a>
    ·
    <a href="#production">PRODUCTION deployment</a>
  </p>
</div>

<div align="center">
  <h2>ABOUT</h2>
</div>

A template for creating a Telegram bot using the Django web framework and [`pyTelegramBotAPI`](https://github.com/eternnoir/pyTelegramBotAPI.git). This project is designed for a robust, production-ready deployment using Docker and Webhooks.

Why Django? It's a powerful and customizable framework. In this project, Django is used for setting up Webhooks via its admin panel and processing updates from Telegram's servers. It can also be easily extended to store data in a database and create complex user interactions.

**Features:**
* **Django Admin Integration:** Manage bot settings and actions directly from the admin panel.
* **Webhook Ready:** Built from the ground up to work with Telegram Webhooks.
* **Dockerized:** Comes with a `docker-compose.yml` for easy and reproducible deployment.
* **Scalable Handler Architecture:** Bot command handlers are split into modules for easy extension.

<hr>

<div align="center">
  <h2>DEV</h2>
</div>

This guide helps you to set up a local environment for development using polling mode.

1. Preparation:

    - Install Git, Python 3.10+, and venv.

      ```
      sudo apt install git python3 python3-venv -y
      ```

    - Get the project:

      ```
      git clone https://github.com/xinitd/django-telegram-bot.git
      cd django-telegram-bot
      ```

2. Environment setup:

    - Set up virtual environment:

      ```
      python3 -m venv venv
      source venv/bin/activate
      ```

    - Install requirements:

      ```
      pip install -r requirements.txt
      ```

    - Create your local environment file:

      ```
      cp .env.template .env
      ```

      *Open the `.env` file and fill in your `SECRET_KEY` and `TELEGRAM_TOKEN`.*

    - Apply database migrations:

      ```
      python manage.py migrate
      ```

3. Run and test:

    - Run the bot:

      ```
      python manage.py runbot
      ```

    - Send the `/start` command to your bot in Telegram.

<hr>

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
