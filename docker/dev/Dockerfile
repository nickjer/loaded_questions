FROM ruby:3.0.1-alpine

RUN apk add --no-cache \
      postgresql-dev \
      tzdata \
      yarn \
      git \
      build-base && \
    addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

ENV LANG C.UTF-8
ENV BUNDLE_PATH vendor/bundle

WORKDIR /app

RUN chown -R app:app /app && chmod 755 /app

USER app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --no-document && \
    bundle config set --local jobs $(nproc) && \
    bundle config set --local retry 3 && \
    bundle install --quiet

COPY package.json yarn.lock ./

RUN yarn --check-files --frozen-lockfile --silent
