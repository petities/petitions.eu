require 'test_helper'

class PetitionTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace
  include Concerns::TruncateString

  setup do
    @petition = petitions(:one)
  end

  test 'strip leading and trailing whitespace' do
    [:name, :description, :initiators, :statement, :request].each do |field|
      assert_strip_whitespace(@petition, field)
    end
  end

  test 'link texts should be truncated' do
    [:link1_text, :link2_text, :link3_text].each do |field|
      assert_truncate_string(@petition, field)
    end
  end

  test 'active_petition_type should choose petition_type' do
    # When set at petition
    assert_equal(@petition.active_petition_type.name, @petition.petition_type.name)

    # When set at office
    petition = petitions(:three)
    assert_equal(petition.active_petition_type.name, petition.office.petition_type.name)
  end

  test 'should enqueue status_update only when status was changed' do
    assert_enqueued_jobs 6 do
      @petition.status = 'staging'
      @petition.save
    end

    assert_no_enqueued_jobs do
      @petition.destroy
    end
  end

  test 'should always have office' do
    @petition.office = nil
    assert @petition.save
    assert_equal @petition.office_id, Office.default_office.id
  end

  test 'should not destroy > 100 signatures' do
    100.times do
      @petition.signatures.create(
        person_name: Faker::Name.name,
        person_email: Faker::Internet.email
      )
    end

    assert_no_difference('Petition.count') do
      @petition.destroy
      assert_not_nil @petition.errors[:base]
      assert_equal @petition.errors[:base], ['Petitie kan niet verwijderd worden omdat er meer dan 100 ondertekeningen zijn']
    end
  end
end
