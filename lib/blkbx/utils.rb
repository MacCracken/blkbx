module Blkbx
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
  end
end
