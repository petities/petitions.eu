class PetitionMailer <  ApplicationMailer
  #
  def petition_announcement_mail(petition)

    @petition = petition
    @office = petition.office
    target = @petition.office.email
    subject = t('mail.request.announcement_subject')
    mail(to: target, subject: subject )
  end

  # get a reference

  def announcement_reminder_mail(petition)

    @petition = petition
    @office = petition.office
    target = @petition.office.email
    subject = t('mail.request.announcement_subject')
    mail(to: target, subject: subject )
  end

  def status_change_mail(petition, target: nil)
    @petition = petition

    subject = t('mail.petition.status.changed_subject')

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

    tld = get_tld(target)

    I18n.with_locale(tld) do
      subject = t('mail.moderation.pending_subject')
      mail(to: target, subject: subject)
    end

  end

  # petition is sending a subject
  def due_next_week_warning_mail(petition)

    subject = t('petition.is.due')
    target = petition.office.email
    mail(to: target, subject: subject)
  end

  # petition should get an answer
  def answer_due_date_request_mail(petition)

    @office = petition.office


    @petition = petition
    target = @petition.office.email

    tld = get_tld(target)

    I18n.with_locale(tld) do
      subject = t('petition.office.please_answer')
      mail(to: target, subject: subject)
    end
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
      action: 'confirm',
      host: 'petities.nl',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.is_answered', {
      title: @petition.name})

    mail(from: 'bounces@petities.nl', reply_to: 'webmaster@petities.nl', to: signature.person_email, subject: subject)
  end

  private

  def get_tld(target)
    locale = :en
    tld = target.split('.').last
    if I18n.available_locales.include? tld.to_sym
      locale = tld
    end
    return locale
  end

end
