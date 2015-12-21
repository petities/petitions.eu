
class SignatureMailer < ApplicationMailer

  # all signatories get a mail that the hand over took place
  def handed_over_signatories_mail(signature)
    @signature = signature
    @petition = @signature.petition
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.handed_over', {
      title: @petition.name})
    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: signature.person_email, subject: subject)
  end

  # signatory gets the answer to the petition
  def inform_user_of_answer_mail(signature, petition, answer)
    @signature = signature
    @petition = petition
    @answer = answer
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.is_answered', {
      title: @petition.name})

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: signature.person_email, subject: subject)
  end

  # subscribed signatory gets a copy of news update with mail flag
  def inform_user_of_news_update_mail(signature, petition)
    @signature = signature
    @petition = petition
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.progress_subject', {
      title: @petition.name})

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: signature.person_email, subject: subject)
  end

  def sig_confirmation_mail(signature)

    @signature = signature

    @confirm_url = url_for(controller: 'signatures',
                           action: 'confirm',
                           #host: 'localhost:3000',
                           host: 'petities.nl',
                           signature_id: @signature.unique_key)

    logger.debug ''
    logger.debug 'Building a confirmation mail.'
    logger.debug @confirm_url
    logger.debug ''

    # find the petition name
    name = 'noname'
    name = @signature.petition.name if @signature.petition.present?

    subject = t('mail.confirm.signature.subject', petition_name: name)

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: @signature.person_email, subject: subject)

  end

  def sig_reminder_confirm_mail(signature)

    @signature = signature
    @petition = @signature.petition

    @confirm_url = url_for(
      controller: 'signatures',
      action: 'confirm',
      #host: 'localhost:3000',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    name = @signature.petition.name if @signature.petition.present?

    subject = t('mail.confirm.signature.subject_again', petition_name: name)

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: @signature.person_email, subject: subject)
  end

  def share_mail(signature, target_email)

    # build the required globals for the template
    @signature = signature
    @petition = @signature.petition
    @person_function = ''
    if not @signature.person_function.nil?
      @person_function = t('mail.mailafriend.note') + ' "%s"' % @signature.person_function
    end
    # build a catch subject line
    subject = t('mail.mailafriend.subject', {
      title: @petition.name})

    # build the mail
    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: target_email, subject: subject)
  end

  def inform_user_of_news_mail(signature, petition, news_update)

    # TODO for reinder

  end


end
