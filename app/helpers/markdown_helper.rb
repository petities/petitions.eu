module MarkdownHelper
  def markdown(text)
    rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                 fenced_code_blocks: false,
                                 strikethrough: true)
    # rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, )
    if text
      rc.render(text).html_safe
    end
  end
end

Slim::Embedded.options[:markdown] = {
  fenced_code_blocks: false,
  strikethrough: true }
