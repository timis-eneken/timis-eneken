# install required libs https://github.com/robinst/taglib-ruby#installation

require 'taglib'
require 'date'

audio_files = Dir["*.mp3"]
audio_files.each do  |f|
  track = 1
  if f.include?('ΜΕΡΟΣ')
    if f.include?("Β'")
      track =  2
    elsif f.include?("Γ'")
      track =  3
    end
  end
  words = f.split(" ")
  year = "20" + "#{words[2].split('-')[-1]}"
  month = words[2].split('-')[1]
  day = words[2].split('-')[0]
  # date = "#{day}/#{month}/#{year}"
  album = "#{words[0]} #{words[1]}"
  artist = "#{words[3]} #{words[4]}"
  title = f.split('.')[0]
  desc = File.read('description.txt')
  comment = desc.strip
  TagLib::MPEG::File.open(f) do |file|
    tag = file.id3v2_tag

    # Write basic attributes
    tag.artist = artist
    tag.title = title
    tag.album = album
    tag.year = year.to_i
    tag.track = track
    show = "Τιμής Ένεκεν"
    host = "Δαυίδ Ναχμίας"
    terms = "CC BY-NC-ND 4.0"
    # tag.comment = comment

    # Add attached picture frame
    podcast_apic = TagLib::ID3v2::AttachedPictureFrame.new
    podcast_apic.mime_type = "image/jpeg"
    podcast_apic.description = artist
    podcast_apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
    podcast_apic.picture = File.open("guest.jpg", 'rb') { |f| f.read }
    tag.add_frame(podcast_apic)

    # Add date
    podcast_date = TagLib::ID3v2::TextIdentificationFrame.new("TDAT", TagLib::String::UTF8)
    podcast_date.text_encoding = TagLib::String::UTF8
    podcast_date.text = "#{day}#{month}"
    tag.add_frame(podcast_date)

    # Add ID3v2 tag album artist (itunes)
    album_artist = TagLib::ID3v2::TextIdentificationFrame.new("TPE2", TagLib::String::UTF8)
    album_artist.text_encoding = TagLib::String::UTF8
    album_artist.text = host
    tag.add_frame(album_artist)

    # Add artist
    artist = TagLib::ID3v2::TextIdentificationFrame.new("TPE1", TagLib::String::UTF8)
    artist.text_encoding = TagLib::String::UTF8
    artist.text = host
    tag.add_frame(artist)

    # Add grouping
    grouping = TagLib::ID3v2::TextIdentificationFrame.new("TIT1", TagLib::String::UTF8)
    grouping.text_encoding = TagLib::String::UTF8
    grouping.text = show
    tag.add_frame(grouping)

    # Add composer
    composer = TagLib::ID3v2::TextIdentificationFrame.new("TCOM", TagLib::String::UTF8)
    composer.text_encoding = TagLib::String::UTF8
    composer.text = host
    tag.add_frame(composer)

    # Add iTunes publisher
    publisher = TagLib::ID3v2::TextIdentificationFrame.new("TPUB", TagLib::String::UTF8)
    publisher.text_encoding = TagLib::String::UTF8
    publisher.text = host
    tag.add_frame(publisher)

    # Add genre
    genre = TagLib::ID3v2::TextIdentificationFrame.new("TCON", TagLib::String::UTF8)
    genre.text_encoding = TagLib::String::UTF8
    genre.text = "Other"
    tag.add_frame(genre)

    # Add ID3v2 copyright
    copyright = TagLib::ID3v2::TextIdentificationFrame.new("TCOP", TagLib::String::UTF8)
    copyright.text_encoding = TagLib::String::UTF8
    copyright.text = terms
    tag.add_frame(copyright)

    # Add ID3v2 comment
    # NOTE: Language needs to be English for iTunes
    f_comment = TagLib::ID3v2::CommentsFrame.new
    f_comment.language = "gre"
    f_comment.text_encoding = TagLib::String::UTF8
    f_comment.description = "περιγραφή εκπομπής"
    f_comment.text = comment
    tag.add_frame(f_comment)

    file.save
  end
end
