module Jar
  import org.jets3t.service.impl.rest.httpclient.RestS3Service
end

module JetS3t
  class RestS3Service < Jar::RestS3Service
    def bucket(name)
      S3Bucket.new(self, name)
    end
  end
end