module UpdateHelper
  def intro_text(text)
    return unless text

    text_array = text.split('. ').slice(0, 2)
    text_array.push('')
    text_array.join('. ').html_safe if text_array
  end

  def read_more_text(text)
    return unless text

    text_array = text.split('. ').slice(2, text.length)
    return unless text_array.present?

    text = text_array.join('. ').html_safe if text_array
    text
  end
end
