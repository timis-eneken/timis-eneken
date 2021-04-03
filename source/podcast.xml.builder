xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
rss_attributes = {
  "version" => "2.0",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
  "xmlns:sy" => "http://purl.org/rss/1.0/modules/syndication/",
  "xmlns:atom" => "http://www.w3.org/2005/Atom",
  "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
  "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
  "xmlns:media" => "http://search.yahoo.com/mrss/"
}

xml.rss rss_attributes do
  xml.channel do
    xml.title "Τιμής Ένεκεν"
    xml.language "el-GR"
    xml.copyright "David Nachmias 2018-2021"
    xml.description "Η εκπομπή 'Τιμής Ένεκεν' εκθέτει το έργο και το πνεύμα Ελλήνων του 20ου και 21ου αιώνα."

    xml.link "https://timis-eneken.github.io/"
    xml.atom :link, href: podcast_feed_url, rel: "self", type: "application/rss+xml"

    xml.itunes :author, "David Nachmias"
    xml.itunes :subtitle, "Τιμής Ένεκεν"
    xml.itunes :explicit, "clean"
    xml.itunes :category, text: "Society & Culture" do
      xml.itunes :category, text: "Relationships"
    end
    xml.itunes :summary, podcast_summary
    xml.itunes :image, href: podcast_logo_uri

    xml.itunes :owner do
      xml.itunes :name, "Panagiotis Atmatzidis"
      xml.itunes :email, "atma@convalesco.org"
    end

    blog('shows').articles.each do |episode|
      xml.item do
        xml.title "#{episode.title} #{episode.data.part}"
        xml.description episode.data.intro
        xml.pubDate episode.date.rfc2822
        xml.guid "#{episode.url}"
        xml.link "https://timis-eneken.github.io#{episode.url}"

        xml.itunes :author, "David Nachmias"
        xml.itunes :title, "#{episode.title} (#{episode.data.part}) #{podcast_author}"
        xml.itunes :subtitle, episode.data.crafts.join(', ')
        xml.itunes :summary, episode.data.intro
        xml.itunes :duration, episode.data.podcast_duration
        xml.itunes :image, href: episode.data.podcast_artwork
        xml.itunes :explicit, "clean"

        xml.enclosure url: episode.data.podcast_audio, length: episode.data.podcast_length, type: "audio/mpeg"
        xml.media :content, url: episode.data.podcast_audio, type: "audio/mpeg"
      end
    end
  end
end
