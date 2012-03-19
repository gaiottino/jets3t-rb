
require 'ap'
require 'jets3t'
require 'fileutils'

module Uuid
  def self.generate
    Java::JavaUtil::UUID.random_uuid.to_s
  end
end

def apr(what, header='')
  ap "== #{header} =="
  ap what
  ap "="*(header.size + 6)
end

def resource_dir
  File.expand_path("../resources", __FILE__)
end

def get_credentials_from_s3cmd_cfg
  aws_secret_path = '~/.s3cfg'
  full_secret_path = File.expand_path(aws_secret_path)
  raise "#{aws_secret_path} not found" unless File.exist?(full_secret_path)

  access_key_id, secret_access_key = '', ''

  File.readlines(full_secret_path).map do |line|
    key, val = line.chomp.split(' = ')
    access_key_id = val if key == 'access_key'
    secret_access_key = val if key == 'secret_key'
  end

  [access_key_id, secret_access_key]
end

def build_credentials
  JetS3t::AWSCredentials.new(*get_credentials_from_s3cmd_cfg)
end
