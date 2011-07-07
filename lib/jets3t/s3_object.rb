# module Jar
#   import org.jets3t.service.model.S3Object
# end

module JetS3t
  class S3Object
    def initialize(s3_object_impl)
      @s3_object = s3_object_impl
    end
    
    def data
      @s3_object.get_data_input_stream.to_io.read
    end
  end
end