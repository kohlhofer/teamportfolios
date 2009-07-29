EMAIL_PREVIEW_TEST_PATH = "test/integration/notification_email_previews"
Rake::TestTask.new(:email_previews => "db:test:prepare") do |t|
  t.libs << "test"
  t.pattern = 'test/integration/notification_email_previews.rb'
  t.verbose = true
end
Rake::Task['email_previews'].comment = "Show email previews (runs a test which displays email text on the mac)"
