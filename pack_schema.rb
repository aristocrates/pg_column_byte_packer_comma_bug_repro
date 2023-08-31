#!/usr/bin/env ruby

# frozen_string_literal: true

require 'active_record'
require 'pg_column_byte_packer'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  port: 5432,
  database: 'postgres',
  username: 'postgres',
  encoding: 'utf8',
  pool: 1
)

SCHEMA_FILENAME = 'table_schema_for_repro.sql'

PgColumnBytePacker::PgDump.sort_columns_for_definition_file(
  SCHEMA_FILENAME,
  connection: ActiveRecord::Base.connection,
)
