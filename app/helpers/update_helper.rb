module UpdateHelper
  def can_edit_update?

    return false unless user_signed_in?

    return true if current_user.has_role?(:admin)

    return true if @petition && current_user.has_role?(:admin, @petition)

    return true if @office && current_user.has_role?(:admin, @office)

  end

  def intro_text(text)
    return unless text
    text_array = text.split('. ').slice(0, 2)
    text_array.push('')
    return text_array.join('. ').html_safe if text_array
  end

  def read_more_text(text)
    return unless text

    text_array = text.split('. ').slice(2, text.length)
    text = text_array.join('. ').html_safe if text_array
    text
  end
end
