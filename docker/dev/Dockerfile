FROM ruby:3.0.1-alpine

RUN apk add --no-cache \
      postgresql-dev \
      tzdata \
      yarn \
      git \
      vim \
      build-base && \
    addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

ENV LANG=C.UTF-8
ENV EDITOR=vim
ENV BUNDLE_PATH=vendor/bundle
ENV PATH=/app/bin:${PATH}

WORKDIR /app

RUN chown -R app:app /app && chmod 755 /app

USER app

COPY --chown=app:app Gemfile Gemfile.lock ./

RUN gem install bundler --no-document && \
    bundle config set --local jobs $(nproc) && \
    bundle config set --local retry 3 && \
    bundle install --quiet

COPY --chown=app:app package.json yarn.lock ./

RUN yarn --check-files --frozen-lockfile --silent
