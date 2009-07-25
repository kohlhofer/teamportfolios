require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  should "know activated emails" do
    assert email_addresses(:alex_primary).active?
    assert email_addresses(:alex_other).active?
    assert email_addresses(:tim_primary).active?
    assert !email_addresses(:tim_other_unactivated).active?
  end
end
