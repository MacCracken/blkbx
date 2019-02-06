RSpec.describe 'VERSION' do
  it 'has a version number' do
    expect(Blkbx::VERSION).not_to be nil
  end
end

RSpec.describe Blkbx::Browser, Blkbx::Performance do
  url = 'https://www.google.com/'
  %I[firefox chrome safari].each do |example|
    describe "#{example.upcase} LOCAL".upcase do
      browser = nil

      it '#BROWSER' do
        browser = Blkbx::Browser.new example
        browser.goto url
        expect(browser.url).to eq url
        expect(browser.ready_state).to eq('complete').or eq('interactive')
      end

      if example != :safari
        it '#PERFORMANCE' do
          dom_release = Blkbx::Performance.response_time(browser)
          raw = Blkbx::Performance.type(browser, :summary, :response_time)
          expect(raw.class).to eq(Integer)
          expect(raw).to be > 0
          expect(raw / 1000).to be >= 0
          expect(raw / 1000).to eq(dom_release.to_i)
        end
      end

      it '#BROWSER-CLOSE' do
        browser.quit || browser.close
      end
    end
  end
end

RSpec.describe Blkbx::Browser, Blkbx::Capabilities do
  let(:caps) { Blkbx::Capabilities.new }
  %I[firefox chrome safari].each do |example|
    describe "#{example.upcase} REMOTE" do
      it '#SET CAPABILITIES' do
        caps[:browser_name] = example
        caps[:takes_screenshot] = 'true'                # Allow Screenshots
        caps[:javascript_enabled] = 'true'              # Allow Javascript
        caps[:native_events] = 'true'                   # Allow NativeEvents
        caps[:css_selectors_enabled] = 'true'           # Allow CSS Selector
        caps[:name] = 'Watir'                           # Naming Driver
        caps['browserstack.ie.enablePopups'] = 'true'   # IE allows popups; JS
        expect(caps.itself).not_to eq(nil)
      end

      #  Requires Selenium-Server running locally to pass
      it '#BROWSER' do
        url = 'https://www.google.com/'
        hub = 'http://127.0.0.1:4444/wd/hub/'
        browser = Blkbx::Browser.new example,
                                     url: hub,
                                     opt: caps
        browser.goto url
        expect(browser.url).to eq url
        browser.quit || browser.close
      end
    end
  end
end
