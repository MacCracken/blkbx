FROM  ruby:latest

ENV   LANG C.UTF-8
ENV   APP_HOME /blkbx

RUN   apt-get update && apt-get upgrade -y
RUN   gem update --system 
RUN   gem update && gem cleanup
RUN   gem install bundler 
RUN   gem install nokogiri
RUN   mkdir $APP_HOME

WORKDIR $APP_HOME
ADD   . $APP_HOME

RUN   bundle install

ENTRYPOINT  ["bash"]