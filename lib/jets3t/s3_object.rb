# module Jar
#   import org.jets3t.service.model.S3Object
# end

require 'delegate'

module JetS3t
  class S3Object < SimpleDelegator
    def initialize(s3_object_impl)
      @s3_object = s3_object_impl
      super @s3_object
    end
    
    def data
      @s3_object.get_data_input_stream.to_io.read
    end

    def io_channel
      input = @s3_object.get_data_input_stream
      java.nio.channels.Channels.newChannel(input)
    end
  end
end
