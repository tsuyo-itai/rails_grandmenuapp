FROM ruby:3.1.2

RUN mkdir /grandmenuapp
WORKDIR /grandmenuapp
COPY Gemfile /grandmenuapp/Gemfile
COPY Gemfile.lock /grandmenuapp/Gemfile.lock

# Bundlerの不具合対策(1)
RUN apt-get update && \
    apt-get install -y tzdata && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs && \
    npm install --global yarn && \
    gem update --system && \
    bundle update --bundler && \
    bundle install

COPY . /grandmenuapp
