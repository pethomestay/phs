# Base off the latest ubuntu release
FROM ubuntu:14.04

# Install dependencies
RUN apt-get update -qq && apt-get install -y curl build-essential libpq-dev wget git zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev nodejs

# Install RVM and Ruby 1.9.3-p547
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ruby-1.9.3-p547"

# Never install rubygem docs
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

# Install bundler
RUN /bin/bash -l -c "gem install bundler"

# Add gemfiles early to cache installed gems
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

# Install app rubygem dependencies
RUN /bin/bash -l -c "bundle install"

# Change and link to the app directory
ADD . /app
WORKDIR /app
