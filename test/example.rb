# example.rb

require_relative '../lib/cumin.rb'

class Example < Cumin


  cumin_accessor :email

  cumin_string :name, ''

  cumin_string :email, "" do |item|
    not item.empty?
  end

  cumin_int :count, 0

  def initialize
    super
    "initializing here."
  end

  def cumin_initialize
  end

  def reverse_email
    @email.reverse!
    cumin_save
  end

end
