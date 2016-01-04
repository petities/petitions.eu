require 'active_support/concern'

module SortPetitions extend ActiveSupport::Concern

  def sort_petitions(petitions)
    @page    = (params[:page] || 1).to_i
    @sorting = params[:sorting] || 'all'
    @order   = params[:order].to_i

    # petitions = Petition.joins(:translations).live
    direction = [:desc, :asc][@order]

    # describe petitions
    case @sorting
    when 'all'
      petitions = petitions.where("status NOT IN ('draft', 'concept', 'staging')")
    when 'open'
      petitions = petitions.live
    when 'concluded'
      petitions = petitions.where(status: 'completed')
    when 'rejected'
      petitions = petitions.where(status: 'rejected')
    when 'sign_elsewhere'
      petitions = petitions.where(status: 'not_signable_here')
    else
      petitions = petitions.live.order(created_at: direction)
    end

    @sorting_options = [
      { type: 'all', label: t('all.sort.all') },
      { type: 'open',           label: t('all.sort.open') },
      { type: 'concluded',      label: t('all.sort.concluded') },
      { type: 'rejected',       label: t('all.sort.rejected') },
      { type: 'sign_elsewhere', label: t('all.sort.sign_elsewhere') }
    ]

    @results_size = petitions.size

    @petitions = petitions.paginate(page: @page, per_page: 12)
    @petitions
  end

  def petitions_by_status(petitions)
    # find petition in state of allow
    @petitions_draft = petitions.where(status: %w(draft concept)).limit(20)
    # find petitions in state of answer
    @petitions_moderate = petitions.where(status: 'staging').limit(20)
    # find petition in state of signable
    @petitions_live = petitions.live.limit(20)
    # find petition in state of answered
    @petitions_inproces = petitions.where("status IN ('to_process', 'in_process')").limit(20)
    #
    @petitions_completed = petitions.where(status: 'completed').limit(20)
    # find petition in state of done/ingetrokken
    @petitions_rejected = petitions.where(status: 'rejected').limit(20)
    # withdrawn..
    @petitions_withdrawn = petitions.where(status: 'withdrawn').limit(20)
    # @petitions = @petitions.paginate(page: @page, per_page: 12)
  end
end
