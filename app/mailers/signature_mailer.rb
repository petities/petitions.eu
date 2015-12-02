
class SignatureMailer < ApplicationMailer

  def sig_confirmation_mail(signature)
    @signature = signature

    @confirm_url = url_for(controller: 'signatures',
                           action: 'confirm',
                           #host: 'localhost:3000',
                           host: 'dev.petitions.eu',
                           signature_id: @signature.unique_key)

    logger.debug 'building a confirmation mail.'
    logger.debug @confirm_url

    # find the petition name
    name = 'noname'
    name = @signature.petition.name if @signature.petition.present?

    subject = t('signature.confirm', name: name)

    mail(to: @signature.person_email, subject: subject)
  end

  def sig_reminder_confirm_mail(signature)

    @signature = signature
    @petition = @signature.petition

    @confirm_url = url_for(
      controller: 'signatures',
      action: 'confirm',
      #host: 'localhost:3000',
      host: 'dev.petitions.eu',
      signature_id: @signature.unique_key)

    name = @signature.petition.name if @signature.petition.present?
    subject = t('signature.confirm', name: name)

    mail(to: @signature.person_email, subject: subject)
  end

  def share_mail(signature, target_email)

    # build the required globals for the template
    @signature = signature
    @petition = @signature.petition

    # build a catch subject line
    subject = t('confirm.info.mailafriend_subject', {
      title: @petition.name})

    # build the mail
    mail(to: target_email, subject: subject)
  end

end
