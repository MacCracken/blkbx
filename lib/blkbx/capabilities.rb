module Blkbx
  # Internalizes and Extends Watir::Browser
  #
  # Documentation http://www.rubydoc.info/gems/watir
  class Browser < Watir::Browser; end

  # Adds Capabilities for Remote Driver
  #
  # Documentation
  # https://selenium.googlecode.com/svn/trunk/docs/api/rb/Selenium/WebDriver/Remote/Capabilities.html
  class Capabilities < Selenium::WebDriver::Remote::Capabilities; end
end
