#!/bin/bash

set -euxo pipefail

initdb --data-checksums --username=postgres --pgdata=/var/lib/postgresql/data_repro
pg_ctl -D /var/lib/postgresql/data_repro -l /var/lib/postgresql/log/repro.log --wait start
psql -U postgres -d postgres -1 -v ON_ERROR_STOP=1 -f column_packing/table_schema_for_repro.sql
(cd /var/lib/postgresql/column_packing && /var/lib/postgresql/.rbenv/bin/rbenv exec bundle exec ruby pack_schema.rb)
pg_ctl -D /var/lib/postgresql/data_repro -l /var/lib/postgresql/log/repro.log --wait stop
