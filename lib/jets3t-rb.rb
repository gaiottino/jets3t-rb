# encoding: utf-8

require 'java'

java.lang.System.set_property('org.apache.commons.logging.Log', 'org.apache.commons.logging.impl.NoOpLog')

require 'ext/commons-httpclient-3.1'
require 'ext/commons-logging-1.1.1'
require 'ext/commons-codec-1.3'
require 'ext/java-xmlbuilder-0.4'
require 'ext/java-xmlbuilder-0.4'
require 'ext/jets3t-0.8.1'


require 'jets3t-rb/aws_credentials'
require 'jets3t-rb/rest_s3_service'
require 'jets3t-rb/s3_bucket'
require 'jets3t-rb/s3_object'
