FROM ruby:alpine

WORKDIR /app
COPY . /app
RUN set -x \
  && apk add --no-cache --virtual .run-deps \
    icu \
    python \
  && apk add --no-cache --virtual .build-deps \
    build-base \
    icu-dev \
    cmake \
  && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && bundle install -j$NPROC \
  && apk del .build-deps
ENV RACK_ENV production
ENV PORT 8080
EXPOSE 8080
CMD ./run.sh
