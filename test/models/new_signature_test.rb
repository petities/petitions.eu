# coding: utf-8

require 'test_helper'

class NewSignatureTest < ActiveSupport::TestCase
  include Concerns::Transliterate

  setup do
    @signature = NewSignature.create(
      petition: petitions(:one),
      person_name: 'Test Name',
      person_email: 'test@example.com'
    )
  end

  test 'should be valid' do
    assert @signature.valid?
  end

  test 'signature should have unique_key after save' do
    assert_not_empty @signature.unique_key
  end

  test 'should have signed_at after save' do
    assert_equal 'Time', @signature.signed_at.class.name
  end

  test 'should make signatures email case insensitive' do
    duplicate_signature = NewSignature.new(
      petition: petitions(:one),
      person_name: 'Test Name',
      person_email: 'TEST@EXAMPLE.COM'
    )
    assert_not duplicate_signature.valid?
    assert duplicate_signature.errors.keys.include?(:person_email)
  end

  test 'should send_reminder_mail for unconfirmed signature' do
    assert_enqueued_jobs 1 do
      @signature.send_reminder_mail
    end
  end

  test 'should increment counter and set timestamp when sending reminder' do
    assert_nil @signature.last_reminder_sent_at
    assert_difference(@signature.reminders_sent) do
      @signature.send_reminder_mail
    end
    assert_not_nil @signature.last_reminder_sent_at
  end

  test 'should not send_reminder_mail without petition' do
    @signature.petition = nil
    assert_enqueued_jobs 0 do
      assert_not @signature.send_reminder_mail
    end
  end

  test 'should not send_reminder_mail for confirmed signature' do
    @signature.person_email = signatures(:four).person_email
    assert_enqueued_jobs 0 do
      assert_difference('NewSignature.count', -1) do
        assert_not @signature.send_reminder_mail
      end
    end
  end

  test 'should transliterate person_email' do
    assert_transliterate(@signature, :person_email)
  end
end
