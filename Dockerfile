# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.0.4
FROM ruby:$RUBY_VERSION

WORKDIR /var/www/service-order-rabbitmq

# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

ADD . .
# ADD Gemfile.lock /var/www/email-api/Gemfile.lock

# RUN bash -c 'bundle install $(( [[ -z "$https_proxy" ]] && echo -n "--jobs $(nproc)") || echo -n "")'
RUN bash -c 'bundle install'

RUN apt-get update --allow-insecure-repositories

EXPOSE 3091

CMD bin/rails s -b 0.0.0.0 -p 3091
