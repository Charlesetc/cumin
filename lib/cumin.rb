#!/usr/bin/env ruby

# cumin.rb

require_relative "./cumin/mysql.rb"

class Cumin

  @cumin_vars = {}

  cumin_first_instance = true

  def cumin_initialize_class

    # Don't call this again:
    self.class.cumin_first_instance = false

    # Instantiate the database
    self.class.cumin_database_instance = self.class.cumin_database.new self.class

    self.class.cumin_vars.keys.each do |name|

      default, type, validation = self.class.cumin_vars[name]
      instance_variable_set("@#{name}", default)
    end

  end

  def initialize
    cumin_initialize_class if self.class.cumin_first_instance
    # Hooks for
    cumin_initialize
    cumin_new

    cumin_save
  end

  def cumin_initialize
  end

  def cumin_new
  end

  def cumin_validate
    cumin_validate_with_block do |error|
      puts error
    end
  end

  def cumin_validate!
    cumin_validate_with_block do |error|
      raise error
    end
  end

  def cumin_validate_with_block
    self.class.cumin_vars.keys.each do |name|
      default, type, validation = self.class.cumin_vars[name]
      value = self.instance_variable_get("@#{name}")
      # puts "<h1 style='color:red; font-size 50px; background:black; display:inline;'>#{name} -- #{value}</h1>"
      if validation and not validation.call(value)
        yield("Validation failed for #{name} of value #{value} in #{self}")
      end
    end
  end

  def cumin_save
    cumin_validate
      self.class.cumin_database_instance.save self
  end

  def cumin_save!
    cumin_validate!
    self.class.cumin_database_instance.save self
  end


  # Class Methods

  # The repeated calling of this is ugly, I know.
  # it's the only way I know how to define a class
  # instance variable before any of the code of
  # child classes are run.
  def self.cumin_ensure
    if not @cumin_ensure_var
      @cumin_ensure_var = true
      @cumin_vars = {}
      @set_database = CuminMySQL
      @database_instance = nil
      @cumin_first_instance = true
    end
  end

  def self.cumin_var(name, default, type, &validation)
    cumin_ensure
    @cumin_vars[name] = [default, type, validation]
  end

  def self.cumin_int(name, default=nil, &validation)
    cumin_ensure
    self.cumin_var(name, default, "INT", &validation)
  end

  def self.cumin_string(name, default=nil, &validation)
    cumin_ensure
    self.cumin_var(name, default, "CHARACTER(255)", &validation)
  end

  def self.cumin_vars
    cumin_ensure
    @cumin_vars
  end

  def self.cumin_accessor(name)
    cumin_ensure
    self.cumin_writer name
    self.cumin_reader name
  end

  def self.cumin_writer(name)
    cumin_ensure
    define_method "#{name}=" do |value|
      instance_variable_set "@#{name}", value
      cumin_save
    end
  end

  def self.cumin_reader(name)
    cumin_ensure
    attr_reader name
  end


  #### Getter and Setter
  ## methods for class instance variables

  def self.cumin_database=(database)
    cumin_ensure
    @set_database = database
  end

  def self.cumin_database
    cumin_ensure
    @set_database
  end

  def self.cumin_database_instance=(database)
    cumin_ensure
    @database_instance = database
  end

  def self.cumin_database_instance
    cumin_ensure
    @database_instance
  end

  def self.cumin_first_instance=(bool)
    @cumin_first_instance = bool
  end

  def self.cumin_first_instance
    @cumin_first_instance
  end


end
