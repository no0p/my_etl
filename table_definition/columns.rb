module TableDefinition
  class Columns

    def self.create_table_statements(conf, db_name)
      column_file = "#{File.dirname(__FILE__)}/columns.csv"
      query = <<-SQL
        SELECT table_name, column_name, column_type, table_schema
        FROM information_schema.columns 
        WHERE table_schema = "#{db_name}"
      SQL
      command = "echo '#{query}' | mysql -h #{conf['host']} -u #{conf['username']} -p#{conf['password']} --batch --raw --default-character-set=utf8  > #{column_file}"

      `#{command}`
      all_tables = []

      @schemas = {}
      File.open(column_file).each_line do |row|
        table, column, type, schema = row.split("\t").map {|i| i.strip}
        if !['mysql','information_schema', 'performance_schema'].include? schema
          @schemas[schema] ||= {}
          @schemas[schema][table] ||= []
          @schemas[schema][table].push({column => type})
        end unless (table == 'table_name' && column == 'column_name' && type == 'column_type')
      end

        error_messages = []
        @schemas.each do |schema, tables|
          tables.each do |table, columns|
            destination_schema = ''
            destination_schema = conf['destination_schema'] + '.' unless (conf['destination_schema'].empty? || conf['destination_schema'].nil?)
            table_definition = "CREATE FOREIGN TABLE #{destination_schema}#{table} ("
            missed_columns = []
            columns.each do |c|
              col, type = c.to_a.flatten
              pg_type = case type
                        when /char/ then 'text'
                        when /bigint/ then 'bigint'
                        when /int/ then 'integer'
                        when /float|double|decimal/ then 'numeric'
                        when /enum/ then 'text'
                        when /blob|binary/ then 'bytea'
                        when /text/ then 'text'
                        when 'date' then 'date'
                        when /time/ then 'timestamp'
                        else
                          missed_columns << col
                        end
              table_definition += "\"#{col}\" #{pg_type}" unless pg_type.nil?
              table_definition += ", " unless c == columns.last
            end
            table_definition += ") "
            table_definition += "SERVER #{conf['foreign_server']} "
            table_definition += "OPTIONS (table '#{schema}.#{table}');"

            if missed_columns.empty?
              all_tables << table_definition
            else
              error_messages << "#{table} was not transferred because columns are missing: #{missed_columns.join(", ")}"
            end
        end
        end

        return all_tables, error_messages
    end
  end
end
