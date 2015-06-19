FROM mhart/alpine-node

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN npm install -g coffeelint && \
    apk --update add ruby ruby-dev ruby-bundler build-base && \
    bundle install -j 4 && \
    apk del build-base && rm -fr /usr/share/ri

COPY . /usr/src/app

CMD ["/usr/src/app/bin/coffeelint"]
