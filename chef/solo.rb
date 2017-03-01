root = File.absolute_path(File.dirname(__FILE__))

cookbook_path [root + '/cookbooks']
ssl_verify_mode :verify_peer
