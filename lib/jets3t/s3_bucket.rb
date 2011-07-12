require 'tempfile'

module Jar
  import org.jets3t.service.model.S3Bucket
  import org.jets3t.service.model.S3Object
end

module JetS3t
  class Location
    ASIA_PACIFIC    = Jar::S3Bucket::LOCATION_ASIA_PACIFIC
    EUROPE          = Jar::S3Bucket::LOCATION_EUROPE
    US              = Jar::S3Bucket::LOCATION_US
  end
  
  class S3Bucket
    def initialize(s3_service, name)
      @s3_service = s3_service
      @bucket = @s3_service.get_bucket(name)
    end
    
    def put(path, file)
      java_file = java.io.File.new(file.path)
      input_stream = java.io.FileInputStream.new(java_file)
      
      object = Jar::S3Object.new(path)
      object.set_data_input_stream(input_stream)
      object.set_content_length(java_file.length)
      object.set_content_type('application/octet-stream')
      
      @s3_service.put_object(@bucket, object)
    end
    
    def get(filename)
      S3Object.new(@s3_service.get_object(@bucket, filename))
    end
  end
end