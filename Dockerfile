FROM python:3.9 AS base

ARG PROJECT_ENV

# poetry:
ENV POETRY_VERSION=1.1.4 \
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=false \
  POETRY_CACHE_DIR='/var/cache/pypoetry' \
  PATH="$PATH:/root/.poetry/bin"

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        awscli \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

RUN curl -sSL 'https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py' | python

# Project initialization:
COPY pyproject.toml ./
RUN echo "$PROJECT_ENV" \
  && poetry install \
    $(if [ "$PROJECT_ENV" = 'production' ]; then echo '--no-dev'; fi) \
    --no-interaction --no-ansi \
  # Cleaning poetry installation's cache for production:
  && if [ "$PROJECT_ENV" = 'production' ]; then rm -rf "$POETRY_CACHE_DIR"; fi


FROM base AS develop

WORKDIR /opt/app
COPY . .
EXPOSE 5031
CMD exec gunicorn --log-config apps/gunicorn_logging.conf apps.main:app -w 2 --timeout 30 -b 0.0.0.0:5031 --limit-request-line 0 --limit-request-field_size 0
