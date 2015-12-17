module MarkdownHelper
  def markdown(text)
    rc = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      fenced_code_blocks: false,
      disable_indented_code_blocks: true,
      strikethrough: true)
    # rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, )
    if text
      rc.render(text).html_safe
    end
  end
end

Slim::Embedded.options[:markdown] = {
  fenced_code_blocks: false,
  disable_indented_code_blocks: true,
  strikethrough: true }
