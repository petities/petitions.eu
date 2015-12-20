class PetitionMailer <  ApplicationMailer
  #
  def status_change_mail(petition, target: nil)
    @petition = petition

    subject = t('Petition.status.changed')

    if target.nil?
      # NOTE petitioner_email can be wrong?
      # should we not send email to admin users?
      target = @petition.petitioner_email
    end

    if @petition.petitioner_email
      mail(to: target, subject: subject )
    end
  end

  # finalize email
  def finalize_mail(petition, target: nil)

    @petition = petition

    if target.nil?
      target = @petition.office.email
    end

    subject = t('petition.moderation.pending')

    mail(to: target, subject: subject)

  end

  # petition is sending a subject
  def warning_due_date_mail(petition)

    subject = t('petition.is.due')
    target = petition.office.email
    mail(to: target, subject: subject)
  end

  # petition should get an answer
  def due_date_ask_for_answer_mail(petition)

    subject = t('petition.office.please_answer')

    @petition = petition

    mail(to: @petition.office.email, subject: subject)
  end

  def reference_number_mail(petition, target="")
    Logger.debug('building reference number mail..')

    subject = t('petition.moderation.we_need_reference')

    if not target
      target = @petition.office.email
    end

    mail(to: target, subject: subject)

  end

  def office_ask_for_answer_due_date_mail(petition)
    Logger.debug('build ask for answer due date mail..')

    subject = t('petition.moderation.we_need_answer')

    mail(to: @petition.office.email, subject: subject)

  end

  def office_ask_for_answer_mail(petition)
    Logger.debug('build ask for answer mail..')

    subject = t('petition.moderation.we_need_answer')

    mail(to: @petition.office.email, subject: subject)

  end

  def adoption_request_signatory_mail(petition, signature)
    @petition = petition
    @signature = signature

    if signature.unique_key.nil?
      signature.send(:generate_unique_key)
      signature.save
    end

    @become_owner_url = url_for(
      controller: 'signatures',
      action: 'become_petition_owner',
      host: 'dev.petitions.eu',
      signature_id: @signature.unique_key)

    subject = t('petition.moderation.we_need_new_owner')

    mail(to: @signature.person_email, subject: subject)
  end

  def welcome_petitioner_mail(petition, user, password)

    @user = user
    @password = password
    @token = user.confirmation_token
    @password = password
    @petition = petition

    subject = t('mail.petition.confirm.subject', {
      petition_name: petition.name
    })

    mail(to: user.email, subject: subject)
  end
  
  def inform_user_of_answer_mail(signature, petition, answer)
    @signature = signature
    @petition = petition
    @answer = answer
    @unique_key = url_for(
      controller: 'signatures',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.is_answered', {
      title: @petition.name})

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: signature.person_email, subject: subject)
  end

end
