# syntax = docker/dockerfile:1.0-experimental
FROM python:3.7-slim as prod
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential git-core openssl libssl-dev libffi6 libffi-dev curl wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /app
COPY . /app
RUN pip install -r alt_requirements/requirements_full.txt
RUN pip install -e .
RUN wget -q -P data/ https://s3-eu-west-1.amazonaws.com/mitie/total_word_feature_extractor.dat
RUN python -m spacy download en_core_web_md && python -m spacy link en_core_web_md en
VOLUME ["/app/projects", "/app/logs", "/app/data"]
EXPOSE 5000
CMD ["python", "-m", "rasa_nlu.server", "--path", "/app/projects"]