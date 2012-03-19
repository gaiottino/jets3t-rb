module JetS3t

  describe "JetS3t upload/download" do
    
    let(:bucket_name)       { 'jets3t-spec-1' }
    let(:service)           { RestS3Service.new(build_credentials) }
    let(:spec_bucket)       { service.bucket(bucket_name) }
    let(:resource)          { File.join resource_dir, "silence-44-s.flac" }
    let(:download_dir)      { File.join Dir.tmpdir, Uuid.generate }
    let(:target)            { "new-resource-1" }
    let(:results)           { { uploaded: [], list: [], downloaded: [] } }
    let(:mime)              { "audio/flac" }
    let(:size)              { "50904" }

    before do
      FileUtils.mkdir download_dir
      results[:uploaded] << spec_bucket.upload(resource, target, mime)
      results[:list].concat spec_bucket.list
    end

    after do
      spec_bucket.delete(target)
      spec_bucket.destroy
      FileUtils.remove_dir(download_dir, true)
    end

    context "upload file binary (audio) file" do

      subject           { results }

      it "after upload S3Object contains metadata and the listing has the file" do
        
        metadata = subject[:uploaded][0].metadata_map
        metadata["Content-Length"].should == size

        subject[:list][0].key.should == target

      end
    end

    context "download binary (audio) file" do

      let(:download_file) { File.join download_dir, Uuid.generate }

      before do
        results[:downloaded][0] = spec_bucket.download(target, download_file)
      end

      subject { results }

      it "after download S3Object contains metadata and the listing has the file" do
        
        metadata = subject[:uploaded][0].metadata_map

        subject[:downloaded][0].should == metadata["Content-Length"].to_i
        FileUtils.compare_file(resource, download_file).should be_true

      end
    end
  end

end
