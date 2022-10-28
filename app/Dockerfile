FROM python:3.9.3-buster

ARG APP_USER=app_user
ARG APP_GROUP=app_group
ARG APP_USER_UID=999

WORKDIR /app

RUN apt-get update && apt-get install libpq-dev python3-dev -y

COPY ./requirements.txt ./
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

ENV PYTHONPATH=/app PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

RUN groupadd --gid ${APP_USER_UID} --system ${APP_GROUP}
RUN useradd --uid ${APP_USER_UID} \
            --gid ${APP_GROUP} \
            --no-create-home \
            --system \
            --shell /bin/false \
            ${APP_USER}

COPY . .

RUN chown -R ${APP_USER}:${APP_GROUP} .

USER ${APP_USER}