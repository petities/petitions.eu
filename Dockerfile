FROM ruby:2.4

LABEL maintainer="Stichting Petities.nl <webmaster@petities.nl>"

# https://github.com/nodesource/distributions#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
      && apt-get install -y nodejs \
      && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 999 appuser \
    && useradd -r -u 999 -g appuser appuser -d /app

RUN mkdir /app && chown 999:999 /app

COPY Gemfile Gemfile.lock ./
RUN chown appuser:appuser Gemfile Gemfile.lock

USER appuser
WORKDIR /app

RUN bundle install

COPY . ./

VOLUME /app
EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

