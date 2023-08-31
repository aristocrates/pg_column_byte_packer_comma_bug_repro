FROM postgres:15

RUN apt-get update && \
  apt-get install -y \
    build-essential \
    curl \
    git \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

USER postgres
WORKDIR /var/lib/postgresql

RUN git clone https://github.com/rbenv/rbenv.git .rbenv
RUN git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build
RUN /var/lib/postgresql/.rbenv/bin/rbenv install 3.2.2
RUN /var/lib/postgresql/.rbenv/bin/rbenv global 3.2.2
ARG BUNDLER_VERSION=2.4.19
RUN /var/lib/postgresql/.rbenv/bin/rbenv exec gem install bundler:${BUNDLER_VERSION}
ARG RUBYGEMS_VERSION=3.4.19
RUN /var/lib/postgresql/.rbenv/bin/rbenv exec gem update --system ${RUBYGEMS_VERSION}

RUN mkdir column_packing
COPY --chown=postgres:postgres Gemfile column_packing/Gemfile
COPY --chown=postgres:postgres Gemfile.lock column_packing/Gemfile.lock
RUN cd column_packing && /var/lib/postgresql/.rbenv/bin/rbenv exec bundle install
COPY --chown=postgres:postgres pack_schema.rb column_packing/pack_schema.rb

RUN mkdir log
VOLUME /var/lib/postgresql/column_packing/table_schema_for_repro.sql
COPY --chown=postgres:postgres entrypoint.sh /var/lib/postgresql/entrypoint.sh
ENTRYPOINT /var/lib/postgresql/entrypoint.sh
