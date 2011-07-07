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
    
    def put(*args)
      if args.length == 1 && args[0].instance_of?(File)
        java_file = java.io.File.new(args[0].path)
        object = Jar::S3Object.new(java_file)
      elsif args.length == 2
        object = Jar::S3Object.new(args[0], args[1])
      else
        raise 'either put(file) or put(filename, data)'
      end

      @s3_service.put_object(@bucket, object)
    end
    
    def get(filename)
      S3Object.new(@s3_service.get_object(@bucket, filename))
    end
  end
end