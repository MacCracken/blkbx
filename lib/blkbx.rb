['watir', 'watir-performance', 'httpclient'].map(&method(:require))

require 'blkbx/browser'
require 'blkbx/capabilities'
require 'blkbx/http'
require 'blkbx/perform'
require 'blkbx/version'

module Blkbx
  class Error < StandardError; end
  # Your code goes here...
end
