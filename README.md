## Overview

This is a small ruby project that connects to a mysql server and writes sql for creating foreign data tables in a postgresql format.  It is designed to work with the mysql foreign data wrapper at https://github.com/bdigital/mysql_fdw

## Installation

Ensure standard mysql command line client is installed.

Setup config.yml file with appropriate connection information such as the mysql host, username, and password.  Also the name of the foreign data wrapper server for this server.

## Usage

```
  ./discover > foreign_data_tables_ddl.sql
```

This will dump the information schema for the columns into columns.csv in the local directory.

Next it will read the csv file and write postgres foreign data table definitions to stdout.

