FROM ruby:3.0.1-alpine AS builder

RUN apk add --no-cache \
      postgresql-dev \
      tzdata \
      yarn \
      git \
      build-base

WORKDIR /app

ENV LANG C.UTF-8
ENV RAILS_ENV production
ENV NODE_ENV production
ENV BUNDLE_JOBS 4
ENV BUNDLE_RETRY 3

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --no-document && \
    bundle config set --local deployment 'true' && \
    bundle config set --local --without 'development test' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install --quiet && \
    rm -rf $GEM_HOME/cache/*

COPY package.json yarn.lock ./

RUN yarn --check-files --frozen-lockfile --silent --production

COPY . ./

# Need to precompile twice because first time does not compile CSS correctly
RUN bundle exec rails assets:precompile --trace || \
    bundle exec rails assets:precompile --trace && \
    yarn cache clean && \
    rm -fr node_modules tmp/cache vendor/assets test

############################################################

FROM ruby:3.0.1-alpine

# Add basic packages
RUN apk add --no-cache \
      libpq \
      tzdata && \
    addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

USER app

COPY --from=builder --chown=app /app /app

# Configure Rails
ENV LANG C.UTF-8
ENV RAILS_ENV production
ENV NODE_ENV production
ENV BUNDLE_PATH 'vendor/bundle'
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

# Expose Puma port
EXPOSE 3000

WORKDIR /app
