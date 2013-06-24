def delete_line_from_file(filename, line)
  # create empty file string
  tmp_file = ''

  # iterate over every line and skip lines that match
  File.open(filename, "r").each_line do |l|
    tmp_file += l unless line.match(l.strip)
  end

  # write tmp file without matching lines
  File.open(filename, 'w') { |file| file.write tmp_file }

  # clear memory
  tmp_file = nil
end


class Object
  def blank?
    self.nil? || self.empty?
  end
end