class read_file(texts)
  File.open(texts,"r") do |text|
  texts_detail = text.read_file
  end
end

class write_file
  File.open("text.txt","w") do |file|
  file.write("This is the text.")
  end
end
