FROM matheuscatalan123/cosmos-midgard:base

WORKDIR /usr/src/app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --jobs 4 --without development production

ADD . .

RUN ln -s /usr/bin/convert /usr/local/bin/convert
RUN ln -s /usr/bin/exiftool /usr/local/bin/exiftool

ENTRYPOINT ["/bin/bash", ".jenkins/ci_script.sh"]

