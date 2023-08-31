#!/bin/sh

cp table_schema_for_repro.sql table_schema_for_repro_copy.sql
docker run \
  --rm \
  -v $(pwd)/table_schema_for_repro_copy.sql:/var/lib/postgresql/column_packing/table_schema_for_repro.sql \
  pg_column_byte_packer_repro:latest
