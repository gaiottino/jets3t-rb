require_relative 'spec_helper'


module JetS3t

  describe "JetS3t exceptions" do
    
    let(:bucket_name)       { 'jets3t-spec-11' }
    let(:service)           { RestS3Service.new(build_credentials) }
    let(:spec_bucket)       { service.bucket(bucket_name) }

    context "trying to use a S3Bucket after its actual S3 bucket was removed" do
      before do
        spec_bucket.destroy
      end

      it "raises an exception" do

        expect { spec_bucket.get("any-thing-at-all") }.to raise_exception(UninitializedBucketException)
        expect { spec_bucket.put("some-path", "any-thing-at-all") }.to raise_exception(UninitializedBucketException)
        expect { spec_bucket.put_data("some-path", "any-thing-at-all") }.to raise_exception(UninitializedBucketException)
        expect { spec_bucket.upload("some-path", "any-thing-at-all") }.to raise_exception(UninitializedBucketException)
        expect { spec_bucket.download("some-path", "any-thing-at-all") }.to raise_exception(UninitializedBucketException)

      end
    end

  end
end
