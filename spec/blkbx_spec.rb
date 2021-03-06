# frozen_string_literal: true

url = 'https://www.google.com/'
hub = 'http://selenium.hub:4444/wd/hub/'
browser = nil
test_browsers = %I[chrome firefox]
test_browsers << :safari if OS.mac? == true
test_browsers << %I[ie edge] if OS.windows? == true
args = %w[--headless --no-sandbox --remote-debugging-port=9222]
opts = Selenium::WebDriver::Chrome::Options.new(args: args)

RSpec.describe 'VERSION' do
  it 'has a version number' do
    expect(Blkbx::VERSION).not_to be nil
  end
end

RSpec.describe Blkbx::HTTP do
  it 'url status equal to 200' do
    expect(Blkbx::HTTP.get(url).status).to eq(200)
  end
end

test_browsers.each do |example|
  RSpec.describe "BlkbxPerformance-#{example.upcase}" do
    it 'browser passes ready state' do
      browser = Blkbx::Browser.new example, url: hub, opt: opts if example == :chrome
      browser = Blkbx::Browser.new example, url: hub if example != :chrome
      browser.goto url
      expect(browser.url).to eq url
      expect(browser.ready_state).to eq('complete').or eq('interactive')
      expect(browser.cookies.class).to eq Watir::Cookies
    end

    if example != :safari
      it 'performance speed greater than or equal to 0' do
        dom_release = Blkbx::Performance.response_time(browser)
        dom_release = dom_release.gsub(/[a-zA-Z: ]/i, '').to_i
        raw = Blkbx::Performance.type(browser, :summary, :response_time)
        expect(raw.class).to eq(Integer)
        expect(raw).to be > 0
        expect(raw / 1000).to be >= 0
        expect(raw / 1000).to eq(dom_release)
      end
    end

    it 'browser closed' do browser.quit || browser.close; end
  end
end

# Requires Selenium-Server locally
test_browsers.each do |example|
  RSpec.describe "BlkbxCapabilities-#{example.upcase}" do
    let(:caps) { Blkbx::Capabilities.new }
    it 'set capabilities is not nil' do
      caps[:browser_name] = example.to_s
      caps[:takes_screenshot] = 'true'                # Allow Screenshots
      caps[:javascript_enabled] = 'true'              # Allow Javascript
      caps[:native_events] = 'true'                   # Allow NativeEvents
      caps[:css_selectors_enabled] = 'true'           # Allow CSS Selector
      caps[:name] = 'Watir'                           # Naming Driver
      caps['browserstack.ie.enablePopups'] = 'true'   # IE allows popups; JS
      expect(caps.browser_name).to eq(example.to_s)
      expect(caps.itself).not_to eq(nil)
    end

    it 'browser passes ready state' do
      browser = Blkbx::Browser.new example, url: hub, opt: caps
      browser.goto url
      expect(browser.url).to eq url
      expect(browser.ready_state).to eq('complete').or eq('interactive')
      expect(browser.cookies.class).to eq Watir::Cookies
    end

    it 'browser closed' do browser.quit || browser.close; end
  end
end
