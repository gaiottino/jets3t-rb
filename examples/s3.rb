$:<< 'lib'

require 'jets3t'

module JetS3t
  AWS_SECRET_PATH = '~/.awssecret'.freeze
  raise "#{AWS_SECRET_PATH} not found" unless File.exist?(File.expand_path(AWS_SECRET_PATH))

  access_key_id, secret_access_key = File.readlines(File.expand_path(AWS_SECRET_PATH)).map(&:chomp)
  credentials = AWSCredentials.new(access_key_id, secret_access_key)
  s3_service = RestS3Service.new(credentials)

  BUCKET_NAME = 'test-bucket-12345'
  # test_bucket = s3_service.create_bucket(BUCKET_NAME, Location::EUROPE)
  test_bucket = s3_service.bucket(BUCKET_NAME)

  # # simple string data
  data = "Hello World!"
  test_bucket.put_data('hello_world.txt', data)
  
  # # file
  FILE_NAME = '/tmp/hello_world.file'
  File.open(FILE_NAME, 'w') {|f| f.write('Hello World!') }
  data = File.new(FILE_NAME)
  test_bucket.put('hello_world.file', data)

  object = test_bucket.get('hello_world.txt')
  p object.data

  object = test_bucket.get('hello_world.file')
  p object.data

  # this should fail and return nil
  object = test_bucket.get('hello_world.txt.apa')
  p object

end