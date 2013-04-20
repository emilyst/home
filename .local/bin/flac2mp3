#!/usr/bin/env ruby
# http://gist.github.com/gists/2998853/
# Forked from http://gist.github.com/gists/124242

filename, quality = ARGV[0], ARGV[1]
abort "Usage: flac2mp3 FLACFILE [V2|V1|V0|320]\nDefault (and recommended) quality is V0." if filename.nil?

qualarg = case quality
    when "V0","V1","V2" then quality
    when "320" then "b 320"
    else "V0"
end

map = {"TITLE" => "--tt", "ARTIST" => "--ta", "ALBUM" => "--tl", "TRACKNUMBER" => "--tn", "GENRE" => "--tg", "DATE" => "--ty"}
args = ""

`metaflac --export-tags-to=- "#{filename}"`.each_line do |line|
    key, value = line.strip.split('=', 2)
    key.upcase!
    args << %Q{#{map[key]} "#{value.gsub('"', '\"')}" } if map[key]
end

basename = File.basename(filename, File.extname(filename))

puts "Encoding #{basename}.mp3"
exec %Q[flac -sdc "#{filename}" | lame -#{qualarg} #{args} - "#{basename}.mp3"]