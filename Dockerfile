# syntax=docker/dockerfile:1.7
FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Create a non-root user with a fixed UID:GID for predictable file permissions
# UID 1000 matches the first non-root user on most Linux hosts,
# which avoids ownership conflicts on bind-mounted volumes.
RUN groupadd --system --gid 1000 app \
    && useradd --system --uid 1000 --gid app --shell /usr/sbin/nologin app

WORKDIR /app

# Install Python dependencies first - this layer is cached
# until requirements.txt changes, so code edits don't trigger pip reinstall.
COPY --chown=app:app requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY --chown=app:app . .

# Drop privileges before running the application
USER app

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "1", "backend.wsgi:application"]
