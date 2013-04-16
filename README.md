## Overview

This is a small ruby project that connects to a mysql server and writes sql for creating foreign data data tables in a postgresql format.  It is designed to work with the mysql foreign data wrapper at https://github.com/bdigital/mysql_fdw

## Installation

Ensure mysql client is installed

Setup config.yml file with appropriate connection information.

## Usage

```
  ./mysql_fdw_discover
```

This will dump the information schema for the columns into columns.csv in the local directory.

Next it will read the csv file and write postgres foreign data table definitions to stdout.

