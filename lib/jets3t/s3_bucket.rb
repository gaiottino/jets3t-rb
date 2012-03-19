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
  
  UninitializedBucketException = Class.new(StandardError)

  class S3Bucket
    include_class org.jets3t.service.S3ServiceException
    NO_SUCH_KEY = 'NoSuchKey'.freeze

    def initialize(s3_service, name)
      @s3_service = s3_service
      @bucket_name = name
      @bucket = @s3_service.get_bucket(name) || create
      try_raise_uninitialized
    end
    
    def create
      @bucket = @s3_service.create_bucket @bucket_name, Location::US
    end

    def put(path, file, mimetype = 'application/octet-stream')
      try_raise_uninitialized
      input_stream = file.to_inputstream
      object = Jar::S3Object.new(clean_path(filename))
      object.set_data_input_stream(input_stream)
      object.set_content_length(file.size)
      object.set_content_type(mimetype)
      data = @s3_service.put_object(@bucket, object)
    end

    def put_data(path, data, mimetype = 'application/octet-stream')
      try_raise_uninitialized
      object = Jar::S3Object.new(clean_path(path), data)
      object.set_content_length(data.size)
      object.set_content_type(mimetype)
      data = @s3_service.put_object(@bucket, object)
    end
    
    def get(filename)
      try_raise_uninitialized
      S3Object.new(@s3_service.get_object(@bucket, clean_path(filename)))
    rescue S3ServiceException => e
      if e.cause.error_code != NO_SUCH_KEY
        raise e
      end
      nil
    end

    def upload local_filename, filename, mimetype = 'application/octet-stream'
      try_raise_uninitialized
      data = nil
      File.open(local_filename) do |f|
        object = Jar::S3Object.new(clean_path(filename))
        object.set_data_input_stream(f.to_inputstream)
        object.set_content_length(f.size)
        object.set_content_type(mimetype)
        data = @s3_service.put_object(@bucket, object)
      end
      data
    end

    def download filename, local_filename
      try_raise_uninitialized
      count = 0
      s3_channel = get_as_nio_channel(filename)
      File.open(local_filename, 'wb') do |f|
        file_chan = f.to_channel
        count = file_chan.transfer_from s3_channel, 0, 9223372036854775807
        file_chan.force true
        file_chan.close
      end
      count
    end
    
    def destroy
      return unless self.list.size == 0
      @s3_service.delete_bucket(@bucket)
      @bucket = nil
    end

    def delete(filename)
      @s3_service.delete_object(@bucket, clean_path(filename))
      true
    rescue Exception => e
      false
    end
    
    def list
      @s3_service.list_objects(@bucket_name)
    end
    
    private

    def try_raise_uninitialized
      raise UninitializedBucketException.new unless @bucket
    end

    def get_as_nio_channel filename
      s3o = self.get(filename) or return
      s3o.io_channel
    end

    def has_object(path)
      list.each do | item |
        return item if item.get_name == path
      end
    end

    # Removed leading /
    def clean_path(path)
      path.gsub(/^\//,'')
    end
  end
end
