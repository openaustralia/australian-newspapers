require 'scraperwiki'
require 'mechanize'

def scrape_detail_page(agent, url)
  page = agent.get(url)
  url = page.at("table[width=900]").at("a")["href"]
  { "url" => url }
end

agent = Mechanize.new
page = agent.get("https://www.thepaperboy.com/australia/newspapers/country.cfm")

page.at("table[width=700]").search("tr")[1..-1].each do |tr|
  tds = tr.search("td")
  record = {
    "name" => tds[0].at("a").inner_text.strip,
    "paperboy_url" => (page.uri + tds[0].at("a")["href"]).to_s,
    "city" => tds[1].inner_text.strip,
    "state" => tds[2].inner_text.strip,
    "language": tds[3].inner_text.strip
  }
  puts record["name"]
  record = record.merge(scrape_detail_page(agent, record["paperboy_url"]))
  ScraperWiki.save_sqlite(["name"], record)
end
