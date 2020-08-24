$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"
ENV["TZ"]                 = "UTC"
ENV["SECRET_CONFIG_PATH"] = "test"

require "yaml"
require "minitest/autorun"
require "amazing_print"
require "sync_attr"
require "semantic_logger"
require "us_address_client"

SemanticLogger.add_appender(file_name: "test.log", formatter: :color)
SemanticLogger.default_level = :debug
