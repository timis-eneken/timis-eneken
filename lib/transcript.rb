require "google/cloud/speech/v1p1beta1"

require "time"

title = "ΤΙΜΗΣ ΕΝΕΚΕΝ 01-09-18 ΓΙΩΡΓΟΣ ΜΑΝΙΩΤΗΣ A' ΜΕΡΟΣ ΑΠΟ 3 (ΑΦΙΕΡΩΜΑ - ΑΡΧΕΙΟ)"
filename = "transcript.txt"

puts "generating transcript file"

File.open(filename, 'w') do |file|
  file.write "#{title}\n"
  file.write ""
end

t1 = Time.new
puts "Start Time : " + t1.inspect

storage_path = "gs://timen/ΤΙΜΗΣ\ ΕΝΕΚΕΝ\ 01-09-18\ ΓΙΩΡΓΟΣ\ ΜΑΝΙΩΤΗΣ\ A\'\ ΜΕΡΟΣ\ ΑΠΟ\ 3\ \(ΑΦΙΕΡΩΜΑ\ -\ ΑΡΧΕΙΟ\).mp3"
# storage_path = "gs://timen/timen1.mp3"

# speech = Google::Cloud::Speech.speech
speech = ::Google::Cloud::Speech::V1p1beta1::Speech::Client.new

config = { encoding:          :MP3,
           sample_rate_hertz: 44_100,
           language_code:     "el-GR" }
audio = { uri: storage_path }

operation = speech.long_running_recognize config: config, audio: audio

puts "Operation started"

operation.wait_until_done!

raise operation.results.message if operation.error?

results = operation.response.results
results.each do |r|
  r.alternatives.each do |a|
    data = "[#{a.confidence}]\n#{a.transcript}\n"
    File.write(filename, data, mode: "a")
    puts "appended data to #{filename}"
  end
end

t2 = Time.new
puts "End Time : " + t2.inspect
