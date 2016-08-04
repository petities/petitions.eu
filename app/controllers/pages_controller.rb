# Serves simple pages
class PagesController < ApplicationController
  before_filter :initialize_help_topics, only: :help

  STATIC_PAGES = %w(about donate help privacy error).freeze

  STATIC_PAGES.each do |name|
    define_method(name) {}
  end

  private

  def initialize_help_topics
    @general = I18n.t('help.general')
    @whilesigning = I18n.t('help.whilesigning')
    @aftersigning = I18n.t('help.aftersigning')
    @writingpetition = I18n.t('help.writingpetition')
  end
end
