require './lib/vagrant-dnsmasq/includes/helper.rb'

random = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join


describe "Helper" do

  it "#delete_line_from_file should delete a line from a file" do
    tmp_file = "/tmp/helper-delete-line-from-file-test-#{random}"
    system "echo \"line 1\n another line\n\na line after an empty line  \nline5\" > #{tmp_file}" 
    delete_line_from_file(tmp_file, Regexp.new("an"))
    IO.read(tmp_file).should eq("line 1\n\nline5\n")
    system("rm #{tmp_file}") if File.exists? tmp_file
  end

end

describe Object do
  it "#blank? should work" do
    "".blank?.should eq(true)
    nil.blank?.should eq(true)
    [].blank?.should eq(true)
    false.blank?.should eq(true)
    0.blank?.should eq(true)

    'foo'.blank?.should eq(false)
    [1].blank?.should eq(false)
    true.blank?.should eq(false)
    1.blank?.should eq(false)
    -1.blank?.should eq(false)

  end
end