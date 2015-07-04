
require "rspec"
require 'mysql2'
require_relative './example.rb'

describe Example do

  client = Mysql2::Client.new(:host => "localhost", :username => "root")

  before(:each) do
    @example = Example.new
  end

  describe "interface" do
    it "has working accessors" do
      expect(@example).to respond_to :email
      expect(@example).to respond_to :email=

      string = "Hello there"
      @example.email = string
      expect(@example.instance_variable_get("@email")).to eq string
    end

    it "generates instance variables" do
      expect(@example.instance_variable_get('@name')).to eq ""
    end

    it "doesn't allow invalid data"
  end

  describe "database" do

    it "is a functioning instance variable" do
      expect(@example.class).to respond_to :cumin_database

      # Store database instance
      history = @example.class.cumin_database_instance

      # Make a nonsense database instance
      @example.class.cumin_database_instance = Example.new

      # It shouldn't work
      expect { @example.cumin_save }.to raise_error NoMethodError

      # Set the database instance back for future tests.
      @example.class.cumin_database_instance = history
    end


    context 'mysql' do

      it 'generates a database' do
        results = client.query('show databases').to_a.map {|x| x['Database']}
        expect(results.join(' ')).to match /cumin_db/
      end

      it 'generates a table for each class' do
        client.query 'use cumin_db'
        results = client.query('show tables').to_a.join(", ")
        expect(results).to match /examples/
      end

      it 'generates columns for each cumin_var'

      it 'saves on creation'

      it 'saves on update'

      it 'makes defaults'

    end


  end

end
