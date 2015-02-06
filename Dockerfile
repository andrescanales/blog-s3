FROM ubuntu:14.04

# Install all dependences
RUN sudo apt-get update
RUN sudo apt-get install -y libssl1.0.0
RUN sudo apt-get install -y openssl
RUN sudo apt-get install -y nodejs
RUN sudo apt-get install -y git
RUN sudo apt-get install -y libpq-dev
RUN mkdir -p ~/blog-s3

# Install RVM
RUN echo 'rvm_path="$HOME/.rvm"' >> ~/.rvmrc
RUN curl -L https://get.rvm.io | bash -s stable
RUN source ~/.rvm/scripts/rvm
RUN type rvm | head -1
RUN echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
RUN rvm install 2.0.0-p481
RUN rvm use 2.0.0 --default
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

WORKDIR ~/blog-s3

# Cache Gemfile steps so we don't run bundle install every time other files change.
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --deployment

ADD . ~/blog-s3

CMD bundle exec rails server
