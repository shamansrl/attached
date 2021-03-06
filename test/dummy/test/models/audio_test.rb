require 'test_helper'

class AudioTest < ActiveSupport::TestCase

  setup do
    @valid = File.open("#{Rails.root}/test/fixtures/audios/audio.wav")
    @small = File.open("#{Rails.root}/test/fixtures/audios/small.wav")
    @large = File.open("#{Rails.root}/test/fixtures/audios/large.wav")
    @invalid = File.open("#{Rails.root}/test/fixtures/audios/invalid.wav")
    @undefined = File.open("#{Rails.root}/test/fixtures/audios/undefined.zip")
  end

  teardown do
    @valid.close
    @small.close
    @large.close
    @invalid.close
    @undefined.close
  end

  test "valid file assignment" do
    @audio = Audio.create(file: @valid)
    assert @audio.valid?, "valid file assignment failed"
    assert @audio.file?, "should have a file"
  end

  test "inavlid file assignment" do
    @audio = Audio.create(file: @invalid)
    assert !@audio.valid?, "invalid file assignment succeeded"
    assert @audio.errors[:file].include? "must be an audio file"
  end

  test "undefined file assignment" do
    @audio = Audio.create(file: @undefined)
    assert !@audio.valid?, "undefined file assignment succeeded"
    assert @audio.errors[:file].include? "extension is invalid"
  end

  test "too large file assignment" do
    @audio = Audio.create(file: @large)
    assert !@audio.valid?, "invalid file assignment succeeded"
    assert @audio.errors[:file].include? "size must be between 2 kilobytes and 2 megabytes"
  end

  test "too small file assignment" do
    @audio = Audio.create(file: @small)
    assert !@audio.valid?, "invalid file assignment succeeded"
    assert @audio.errors[:file].include? "size must be between 2 kilobytes and 2 megabytes"
  end

  test "no file assignment" do
    @audio = Audio.create()
    assert !@audio.valid?, "invalid file assignment succeeded"
    assert @audio.errors[:file].include? "must be attached"
  end

end
