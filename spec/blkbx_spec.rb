RSpec.describe 'VERSION' do
  it 'has a version number' do
    expect(Blkbx::VERSION).not_to be nil
  end
end

url = 'https://www.google.com/'

RSpec.describe Blkbx::HTTP do
  it 'url status equal to 200' do
    expect(Blkbx::HTTP.get(url).status).to eq(200)
  end
end

hub = 'http://127.0.0.1:4444/wd/hub/'
browser = nil
test_browsers = %I[chrome firefox]
test_browsers << :safari if OS.mac? == true
test_browsers << %I[ie edge] if OS.windows? == true

test_browsers.each do |example|
  RSpec.describe "BlkbxPerformance-#{example.upcase}" do
    it 'browser passes ready state' do
      args = %w[--headless --remote-debugging-port=9222]
      opts = Selenium::WebDriver::Chrome::Options.new(args: args)
      browser = Blkbx::Browser.new example, opt: opts if example == :chrome
      browser = Blkbx::Browser.new example if example != :chrome
      browser.goto url
      expect(browser.url).to eq url
      expect(browser.ready_state).to eq('complete').or eq('interactive')
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
      caps[:takes_screenshot] = 'true'
      caps[:javascript_enabled] = 'true'
      caps[:native_events] = 'true'
      caps[:css_selectors_enabled] = 'true'
      caps[:name] = 'Watir'
      caps['browserstack.ie.enablePopups'] = 'true' # IE allows popups
      expect(caps.browser_name).to eq(example.to_s)
      expect(caps.itself).not_to eq(nil)
    end

    it 'browser passes ready state' do
      browser = Blkbx::Browser.new example, url: hub, opt: caps
      browser.goto url
      expect(browser.url).to eq url
      expect(browser.ready_state).to eq('complete').or eq('interactive')
    end

    it 'browser closed' do browser.quit || browser.close; end
  end
end
