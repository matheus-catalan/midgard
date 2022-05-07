FROM ruby:2.7.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends default-jdk postgresql-client 

# ENV DOCKERIZE_VERSION v0.6.1
# RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz --quiet \
#     && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /usr/src/app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler -v 2.0.2

# RUN bundle install --jobs 20 --retry 5
RUN bundle check || bundle install


COPY . .

EXPOSE 8080

CMD ["rails", "-s"]