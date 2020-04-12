FROM lambci/lambda:build-ruby2.5

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install -y mysql-devel nodejs
RUN npm install -g serverless
RUN gem install bundler:1.17.3 && bundle config set deployment 'true'

ADD Gemfile* package*.json /var/task/

# deployment prep
RUN gem update bundler \
    && bundle config --local build.mysql2 --with-mysql2-config=/usr/lib64/mysql/mysql_config \
    && bundle install --path=vendor/bundle --without=development

ADD ./lib /var/task/lib
ADD ./routines /var/task/routines
ADD serverless.yml /var/task/
RUN cp -a /usr/lib64/mysql/*.so.* /var/task/lib/

CMD bash
