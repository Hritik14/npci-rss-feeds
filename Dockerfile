#hadolint ignore=DL3007
FROM nginx:latest

#hadolint ignore=DL3008
RUN apt-get update \
        && apt-get -y install \
            ruby \
            php \
            libyaml-dev \
            bundler \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN php generate.php

#hadolint ignore=DL3028
RUN gem install bundler \
    &&  bundle install \
    &&  bundle exec weneedfeed build --base-url="http://localhost" \
    && cp -r output/* /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
