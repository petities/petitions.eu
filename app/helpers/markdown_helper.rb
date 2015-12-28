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
end

Slim::Embedded.options[:markdown] = {
  fenced_code_blocks: false,
  disable_indented_code_blocks: true,
  strikethrough: true }
