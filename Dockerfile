FROM    ruby:latest

ENV LANG C.UTF-8
ARG user

RUN     apt-get update
RUN     gem update
RUN     gem install bundler
RUN     gem install nokogiri

ENV APP_HOME /blkbx
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
#RUN     git clone https://github.com/MacCracken/blkbx.git
#RUN     cd blkbx && bin/setup

#WORKDIR     /blkbx
#ENTRYPOINT ["/blkbx/bin/console"]
#CMD ["--help"]
