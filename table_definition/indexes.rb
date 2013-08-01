require 'csv'

module TableDefinition
  class Indexes

    def self.fetch_index_definition(conf, db_name)
      query = <<-SQL
        select * from information_schema.statistics WHERE TABLE_SCHEMA="#{db_name}"
      SQL
      command = "echo '#{query}' | mysql -h #{conf['host']} -u #{conf['username']} -p#{conf['password']} --batch --raw --default-character-set=utf8"
    end

    def self.create_index_statements(conf, db_name)
      command = fetch_index_definition(conf, db_name)
      indexes = []
      index_string = ""
      CSV.parse(`#{command}`, :col_sep => "\t") do |row|

        table_schema = row[1]
        table_name   = row[2]
        non_unique   = row[3]
        index_schema = row[4]
        index_name   = row[5]
        seq_in_index = row[6].to_i
        column_name  = row[7]
        nullable     = row[12]

        if index_name == "PRIMARY"
          indexes << "ALTER TABLE #{conf['mirror_schema']}.#{table_name} ADD PRIMARY KEY (#{column_name});"
          index_string = ""
        elsif seq_in_index == 1
          index_string << ");" unless index_string.empty?
          indexes << index_string unless index_string.empty?
          index_string = ""
          index_string << "CREATE INDEX #{index_name} ON #{conf['mirror_schema']}.#{table_name} (#{column_name}"
        else
          index_string << ", #{column_name}"
        end
      end
      indexes
    end
  end
end
