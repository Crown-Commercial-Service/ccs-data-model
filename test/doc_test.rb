require 'test/unit'
require_relative '../src/doc'
require_relative '../model/fm'
include DataModel

class DocTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  PATH = "out/test/"
  NAME = "doctest"

  def setup
    @d = Doc.new(PATH, NAME)
    if File.file?(@d.docfile)
      File.delete(@d.docfile)
    end
  end


  def test_dot
    assert_equal("#{PATH}doc/#{NAME}.md", @d.docfile, "file name")
    assert(!File.file?(@d.docfile), "no dotfile")
    @d.document( Category::FM)
    assert(File.file?(@d.docfile), "file created")
  end
end