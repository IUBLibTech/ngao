# system dependency image
FROM ruby:2.7 AS ngao-sys-deps

# TODO: setup app user inside the container instead of running the Rails processes as root
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} app_archives && \
    useradd -m -l -g app_archives -u ${USER_ID} app_archives && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential nodejs yarn
RUN yarn && \
    yarn config set no-progress && \
    yarn config set silent

###
# ruby dependencies image
FROM ngao-sys-deps AS ngao-deps

RUN mkdir /app && chown app_archives:app_archives /app
WORKDIR /app

RUN mkdir /container-data && chown app_archives:app_archives /container-data
VOLUME /container-data

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY --chown=app_archives:app_archives Gemfile Gemfile.lock ./
RUN gem install bundler -v "~> 2.4.22" && \
    bundle install -j 2 --retry=3 --deployment --without development

COPY --chown=app_archives:app_archives . .

ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_ENV production

ENTRYPOINT ["bundle", "exec"]

###
# Queue processing image
#FROM ngao-deps as ngao-delayed-job
#ARG SOURCE_COMMIT
#ENV SOURCE_COMMIT $SOURCE_COMMIT
#CMD ./bin/delayed_job

###
# webserver image
FROM ngao-deps as ngao-web
RUN bundle exec rake assets:precompile
RUN bundle exec sass ./app/assets/stylesheets/print.scss ./public/assets/print.scss
RUN ls -l ./public/assets/print.scss
RUN mkdir /app/tmp/pids
EXPOSE 3000
ARG SOURCE_COMMIT
ENV SOURCE_COMMIT $SOURCE_COMMIT
CMD puma -b tcp://0.0.0.0:3000
