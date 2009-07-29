#!/usr/bin/env ruby

root = File.expand_path(File.dirname(__FILE__) + '/../')
require root + '/config/environment'
require root + '/app/models/email_address'

puts "About to purge orhpaned email addresses:"
purged = EmailAddress.purge_orphaned!
puts purged.join("\n")