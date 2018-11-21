require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new
page = agent.get("https://www.thepaperboy.com/australia/newspapers/country.cfm")

page.at("table[width=700]").search("tr")[1..-1].each do |tr|
  tds = tr.search("td")
  name = tds[0].at("a").inner_text.strip
  paperboy_url = (page.uri + tds[0].at("a")["href"]).to_s
  city = tds[1].inner_text.strip
  state = tds[2].inner_text.strip
  language = tds[3].inner_text.strip
  record = { name: name, paperboy_url: paperboy_url, city: city, state: state,
             language: language }
  p record
end

# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")
