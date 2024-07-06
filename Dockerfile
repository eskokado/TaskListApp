FROM ruby:3.3.1

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn libvips

RUN mkdir /app

WORKDIR /app

COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock

RUN gem install bundler -v 2.5.7

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

# COPY app/package.json /app/package.json
# COPY app/yarn.lock /app/yarn.lock

RUN yarn install

COPY app /app

# para pulma #1
RUN mkdir -p /app/tmp/pids
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

# para pulma #2
ENTRYPOINT ["entrypoint.sh"]
CMD [ "bundle", "exec", "puma", "-C", "config/puma.rb" ]
