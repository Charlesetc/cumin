#!/usr/bin/env ruby

# mysql.rb

require 'mysql2'

class CuminMySQL

  def initialize(class_name)

    @sql = Mysql2::Client.new(
      host: (self.class.host || 'localhost'),
      username: (self.class.username || 'root')
    )

    @class_name = class_name # class of Cumin object

    @sql.query 'CREATE DATABASE IF NOT EXISTS cumin_db'
    @sql.query 'USE cumin_db'
    @sql.query "CREATE TABLE IF NOT EXISTS #{class_name.to_s.downcase}s (test int)"

  end


  def save(object)
  end


  ## Class methods

  class << self
    attr_accessor :host, :username
  end

end
