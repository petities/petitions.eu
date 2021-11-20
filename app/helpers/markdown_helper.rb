module MarkdownHelper
  def markdown(text)
    renderer = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(filter_html: true),
      fenced_code_blocks: false,
      disable_indented_code_blocks: true,
      strikethrough: true,
      tables: true,
      footnotes: true
    )
    renderer.render(text.to_s).html_safe if text
  end

  def strip_markdown(text)
    require 'redcarpet/render_strip'

    renderer = Redcarpet::Render::StripDown.new
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(strip_tags(text.to_s))
  end
end

Slim::Embedded.options[:markdown] = {
  fenced_code_blocks: false,
  disable_indented_code_blocks: true,
  strikethrough: true,
  tables: true,
  footnotes: true
}
