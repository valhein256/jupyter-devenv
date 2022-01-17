FROM python:3.9 AS build

RUN apt-get update
RUN apt-get install -y \
        build-essential

RUN apt-get install -y \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev 

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/lib

# poetry:
ENV POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=false \
  POETRY_CACHE_DIR='/var/cache/pypoetry' \
  PATH="$PATH:/root/.poetry/bin"

RUN curl -sSL 'https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py' | python

# Project initialization:
COPY ./jupyter/pyproject.toml ./
COPY ./jupyter/poetry.lock ./

RUN poetry install --no-interaction --no-ansi
RUN rm -rf "$POETRY_CACHE_DIR"

WORKDIR /opt/app
