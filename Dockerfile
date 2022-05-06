FROM ruby:2.7.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends default-jdk postgresql-client 

# ENV DOCKERIZE_VERSION v0.6.1
# RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz --quiet \
#     && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /usr/src/app

COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock

RUN bundle install --jobs 20 --retry 5

COPY . .

EXPOSE 8080

CMD ["rails", "server", "-p", "8080", "-b", "0.0.0.0"]
CMD ["rails", "-s"]

# FROM ruby:2.7.2-alpine


# RUN apk update && \
#     apk upgrade && \
#     apk add \
#     ruby-dev \
#     build-base \
#     openjdk11 \
#     git \
#     postgresql-client \
#     postgresql-dev && \
#     rm -rf /var/cache/apk/*

# WORKDIR /usr/src/app

# COPY Gemfile Gemfile

# RUN bundle install --jobs 20 --retry 5

# COPY . .

# EXPOSE 8080
# CMD ["rails", "-s"]