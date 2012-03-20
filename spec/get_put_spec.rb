require_relative 'spec_helper'


module JetS3t

  describe "JetS3t get/put" do

    let(:bucket_name)       { test_bucket_name }
    let(:service)           { RestS3Service.new(build_credentials) }
    let(:spec_bucket)       { service.bucket(bucket_name) }
    let(:resource)          { File.open File.join(resource_dir, "silence-44-s.flac") }
    let(:target)            { "new-resource-1" }
    let(:results)           { { uploaded: [], list: [], downloaded: [] } }
    let(:mime)              { "audio/flac" }
    let(:size)              { "50904" }

    before do
      results[:uploaded] << spec_bucket.put(target, resource, mime)
      results[:list].concat spec_bucket.list
    end

    after do
      spec_bucket.delete(target)
      spec_bucket.destroy
    end

    context "put file binary (audio) file" do

      subject           { results }

      it "after put S3Object contains metadata and the list has the file" do

        metadata = subject[:uploaded][0].metadata_map
        metadata["Content-Length"].should == size

        subject[:list][0].key.should == target

      end
    end

    context "get binary (audio) file" do

      before do
        results[:downloaded][0] = spec_bucket.get(target)
      end

      subject { results }

      it "after get, the S3Object returned is equal to the resource" do

        key = subject[:uploaded][0].key

        subject[:downloaded][0].key.should == key
        subject[:downloaded][0].verifyData(java.io.File.new(resource.path)).should be_true

      end
    end
  end
end
