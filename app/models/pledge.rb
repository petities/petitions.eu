class Pledge < ActiveRecord::Base
  extend ActionView::Helpers::TranslationHelper

  INFLUENCE_OPTIONS = [
    [t('confirm.form.pledge.expert') , 'expert'],
    [t('confirm.form.pledge.asseenontv'), 'asseenontv'],
    [t('confirm.form.pledge.withreaders'), 'withreaders'],
    [t('confirm.form.pledge.ngomember'), 'ngomember'],
    [t('confirm.form.pledge.partymember'), 'partymember'],
    [t('confirm.form.pledge.employer'), 'employer']
  ]

  SKILL_OPTIONS = [
    [t('confirm.form.pledge.experienced'), 'experienced'],
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

  MONEY_OPTIONS = [
    [t('confirm.form.money.1'), '1'],
    [t('confirm.form.money.5'), '5'],
    [t('confirm.form.money.10'), '10'],
    [t('confirm.form.money.25'), '25'],
    [t('confirm.form.money.50'), '50']
  ]
end
