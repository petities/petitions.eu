module MarkdownHelper
  def markdown(text)
    rc = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      fenced_code_blocks: false,
      disable_indented_code_blocks: true,
      strikethrough: true)
    # rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, )
    rc.render(text).html_safe if text
  end

  def strip_markdown(text)
    require 'redcarpet/render_strip'

    renderer = Redcarpet::Render::StripDown.new
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text)
  end
end

Slim::Embedded.options[:markdown] = {
  fenced_code_blocks: false,
  disable_indented_code_blocks: true,
  strikethrough: true }
