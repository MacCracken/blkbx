['watir', 'watir-performance'].map(&method(:require))

require 'blkbx/version'
require 'blkbx/driver'
require 'blkbx/perform'
require 'blkbx/utils'

module Blkbx
  class Error < StandardError; end
  # Your code goes here...
end
