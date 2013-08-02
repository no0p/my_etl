## Overview

This is a small ruby project that connects to a mysql server and writes sql for creating foreign data tables in a postgresql format.  It is designed to work with the mysql foreign data wrapper at https://github.com/bdigital/mysql_fdw

A database can be copied from mysql to psql in the following manner:

discover -d mysqldbname -s temp_schema -m public  | psql -U username -d pgdbname

## Installation

A.  Ensure standard mysql command line client is installed.

B.  Setup config.yml file with appropriate connection information such as the mysql host, username, and password.  Also the name of the foreign data wrapper server for this server.

```
host: localhost
username: 
password: 
foreign_server: mysql_svr
destination_schema: foreign_migration
```

## Usage

```
  ./discover > foreign_data_tables_ddl.sql
```

This will dump the information schema for the columns into **columns.csv** in the local directory.

Also it will dump executable sql for the foreign tables into **foreign_data_tables_ddl.sql**.

Finally you can add the tables as expected with:

```
psql -d mydb < foreign_data_tables_ddl.sql
```

Be sure to check the mysql foreign data wrapper documentation for installing the extension.
