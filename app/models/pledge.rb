class Pledge < ActiveRecord::Base
  extend ActionView::Helpers::TranslationHelper

  belongs_to :petition
  belongs_to :signature

  validates :feedback, length: { maximum: 255 }, allow_blank: true

  before_create :set_petiton_id

  INFLUENCE_OPTIONS = [
    [t('confirm.form.pledge.expert'), 'expert'],
    [t('confirm.form.pledge.asseenontv'), 'asseenontv'],
    [t('confirm.form.pledge.withreaders'), 'withreaders'],
    [t('confirm.form.pledge.ngomember'), 'ngomember'],
    [t('confirm.form.pledge.partymember'), 'partymember'],
    [t('confirm.form.pledge.employer'), 'employer']
  ]

  SKILL_OPTIONS = [
    [t('confirm.form.pledge.experienced'), 'experienced'],
    [t('confirm.form.pledge.communicator'), 'communicator'],
    [t('confirm.form.pledge.researcher'), 'researcher'],
    [t('confirm.form.pledge.copywriter'), 'copywriter'],
    [t('confirm.form.pledge.publicspeaker'), 'publicspeaker'],
    [t('confirm.form.pledge.mediatrained'), 'mediatrained'],
    [t('confirm.form.pledge.performer'), 'performer'],
    [t('confirm.form.pledge.organiser'), 'organiser'],
    [t('confirm.form.pledge.host'), 'host'],
    [t('confirm.form.pledge.carpooler'), 'carpooler'],
    [t('confirm.form.pledge.other'), 'other']
  ]

  MONEY_OPTIONS = ['5', '10', '25', '50'].freeze

  private

  def set_petiton_id
    self.petition = signature.petition if petition.blank?
  end
end
