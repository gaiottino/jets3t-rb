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
    include_class org.jets3t.service.S3ServiceException
    NO_SUCH_KEY = 'NoSuchKey'.freeze

    def initialize(s3_service, name)
      @s3_service = s3_service
      @bucket_name = name
      @bucket = @s3_service.get_bucket(name)
    end
    
    def put(path, file)
      clean_path(path)
      java_file = java.io.File.new(file.path)
      input_stream = java.io.FileInputStream.new(java_file)
      
      object = Jar::S3Object.new(path)
      object.set_data_input_stream(input_stream)
      object.set_content_length(java_file.length)
      object.set_content_type('application/octet-stream')
      data = @s3_service.put_object(@bucket, object)
    end

    def put_data(path, data)
      clean_path(path)
      object = Jar::S3Object.new(path, data)
      object.set_content_length(data.size)
      object.set_content_type('application/octet-stream')
      data = @s3_service.put_object(@bucket, object)
    end
    
    def get(filename)
      clean_path(filename)
      S3Object.new(@s3_service.get_object(@bucket, filename))
    rescue S3ServiceException => e
      if e.cause.error_code != NO_SUCH_KEY
        raise e
      end
      nil
    end
    
    def delete(filename)
      clean_path(filename)
      @s3_service.delete_object(@bucket, filename)
      true
    rescue Exception => e
      false
    end
    
    def list
      @s3_service.list_objects(@bucket_name)
    end
    
    private
      def has_object(path)
        list.each do | item |
          return item if item.get_name == path
        end
      end
      # Removed leading /
      def clean_path(path)
        path.slice!(0) if path[0] == '/'
      end
  end
end
