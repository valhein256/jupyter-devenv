FROM python:3.9 AS base

# poetry:
ENV POETRY_NO_INTERACTION=1 \
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

WORKDIR /usr/local/lib

RUN curl -sSL 'https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py' | python

# Project initialization:
COPY ./service/pyproject.toml .

RUN poetry install --no-interaction --no-ansi
RUN rm -rf "$POETRY_CACHE_DIR"

FROM base AS develop

WORKDIR /opt/app
COPY ./service .
EXPOSE 5031
CMD exec gunicorn --log-config gunicorn_logging.conf main:app -w 2 --timeout 30 -b 0.0.0.0:5031 --limit-request-line 0 --limit-request-field_size 0
