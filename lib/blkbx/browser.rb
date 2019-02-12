# frozen_string_literal: true

module Blkbx
  # Internalizes and Extends Watir::Browser
  #
  # Documentation http://www.rubydoc.info/gems/watir/Watir/Browser
  class Browser < Watir::Browser; end

  # Extending the Browser
  class Browser
    # Traditional Browser Goto with some Error retry catches
    #
    # @param [String, #read] reads page path
    # @return [goto(@param)] Adds ability to retry on common Net::Errors
    def test_view(page)
      tries ||= 3
      begin
        goto(page)
      rescue Net::ReadTimeout, Net::HTTPRequestTimeOut, Errno::ETIMEDOUT => err
        puts "#{err.class} detected, retrying operation"
        back
        (tries -= 1).zero? ? raise : retry
      end
    end

    # Logs Class pulls Browser Logs
    # Only Applicable to Chrome Browser
    class Logs
      def self.get(browser)
        browser.driver.manage.logs.get(:browser)
      end

      def self.get_type(browser, type)
        error_type = type.to_s.upcase
        errors = []
        getLogs(browser).each do |log|
          errors << log.to_s if log.level == error_type
        end
        errors
      end
    end
  end
end
