RSpec.describe Blkbx do
  it 'has a version number' do
    expect(Blkbx::VERSION).not_to be nil
  end

  describe Blkbx::Browser do
    test_browsers = %I[firefox chrome safari]
    test_browsers.each do |example|
      describe example.upcase do
        it '#WORKS' do
          url = 'https://www.google.com/'
          browser = Blkbx::Browser.new example
          browser.goto url
          expect(browser.url).to eq url
          expect(browser.ready_state).to eq('complete').or eq('interactive')
          puts Blkbx::Performance.response_time(browser)
          browser.quit || browser.close
        end
      end
    end
  end
end
