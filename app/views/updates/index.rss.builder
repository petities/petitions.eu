xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title t('updates.rss.title')
    xml.description t('updates.rss.description')
    xml.link updates_url(format: :rss)
    xml.atom:link, href: updates_url(format: :rss), rel: 'self', type: 'application/rss+xml'
    @updates.each do |update|
      xml.item do
        xml.title update.title
        xml.description strip_markdown(update.text)
        xml.pubDate update.created_at.to_s(:rfc822)
        xml.link update_url(update)
        xml.guid update_url(update)
      end
    end
  end
end
