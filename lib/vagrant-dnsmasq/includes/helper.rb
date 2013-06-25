def delete_line_from_file(filename, regex)
  # create empty file string
  tmp_file = ''

  # iterate over every line and skip lines that match
  File.open(filename, "r").each_line do |l|
    tmp_file += l unless regex.match(l.strip)
  end

  # write tmp file without matching lines
  File.open(filename, 'w') { |file| file.write tmp_file }

  # clear memory
  tmp_file = nil
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end