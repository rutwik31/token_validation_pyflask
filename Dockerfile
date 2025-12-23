FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies required by some DB drivers (pymssql may need freetds)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc freetds-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies (including gunicorn for production serving)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Copy application code
COPY . .

EXPOSE 5000

# Run with gunicorn; module is `app:app` (app.py defines `app`)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
