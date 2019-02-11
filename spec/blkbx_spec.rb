RSpec.describe 'VERSION' do
  it 'has a version number' do
    expect(Blkbx::VERSION).not_to be nil
  end
end

url  = 'https://www.google.com/'
args = %w[no-sandbox headless disable-dev-shm-usage]
test_browsers = %I[chrome firefox]
test_browsers << :safari if OS.mac? == true
test_browsers << %I[ie edge] if OS.windows? == true
opts = Selenium::WebDriver::Chrome::Options.new(args: args)
browser = nil

test_browsers.each do |example|
  RSpec.describe "BlkbxPerformance-#{example.upcase}" do
    it '#BROWSER' do
      browser = Blkbx::Browser.new example, opt: opts if example != :chrome
      browser = Blkbx::Browser.new example if example == :chrome
      browser.goto url
      expect(browser.url).to eq url
      expect(browser.ready_state).to eq('complete').or eq('interactive')
    end

    if example != :safari
      it '#PERFORMANCE' do
        dom_release = Blkbx::Performance.response_time(browser)
        dom_release = dom_release.gsub(/[a-zA-Z: ]/i, '').to_i
        raw = Blkbx::Performance.type(browser, :summary, :response_time)
        expect(raw.class).to eq(Integer)
        expect(raw).to be > 0
        expect(raw / 1000).to be >= 0
        expect(raw / 1000).to eq(dom_release)
      end
    end

    it '#BROWSER-CLOSE' do
      browser.quit || browser.close
    end
  end
end

test_browsers.each do |example|
  RSpec.describe "BlkbxCapabilities-#{example.upcase}" do
    let(:caps) { Blkbx::Capabilities.new }
    it '#SET CAPABILITIES' do
      # Allow Screenshots, Javascript, NativeEvents, CSS Selector
      caps[browser_name: example, takes_screenshot: 'true',
           javascript_enabled: 'true', native_events: 'true',
           css_selectors_enabled: 'true', name: 'Watir']
      # IE allows popups
      caps['browserstack.ie.enablePopups'] = 'true'
      expect(caps.itself).not_to eq(nil)
    end

    #  Requires Selenium-Server running locally to pass
    it '#BROWSER' do
      hub = 'http://127.0.0.1:4444/wd/hub/'
      browser = Blkbx::Browser.new example, url: hub, opt: caps
      browser.goto url
      expect(browser.url).to eq url
      expect(browser.ready_state).to eq('complete').or eq('interactive')
      browser.quit || browser.close
    end
  end
end
