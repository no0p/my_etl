## Overview

MyETL is a ruby script that connects to a mysql server and writes sql for creating foreign data tables in a postgresql format.

Optionally it can generate the SQL to create a mirror database in postgresql effectively make a postgres replica of the data in your mysql system.

## Installation

-- git clone https://github.com/no0p/my_etl.git
-- Requires the mysql command line utility
-- Requires the mysql_fdw from https://github.com/no0p/mysql_fdw to be installed in the target postgresql database

## Usage

```
my_etl -d mysqldbname -s temp_schema -m public  | psql -U pgusername -d pgdbname
```

This will dump the information schema for the columns into **columns.csv** in the local directory.

Also it will dump executable sql for the foreign tables into **foreign_data_tables_ddl.sql**.

Finally you can add the tables as expected with:

```
psql -d mydb < foreign_data_tables_ddl.sql
```

Be sure to check the mysql foreign data wrapper documentation for installing the extension.

## A Note on Security

Leaving password blank to the command line utility will result in the user being prompted for a password.

If automating process, I'd recommend installing a my.cnf file in the users home directory to avoid entering password.
