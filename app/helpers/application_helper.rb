module ApplicationHelper

  def title(text, &block)
    text = t(text) if text.is_a?(Symbol)
    content_for(:title, text + ' ')
    content_tag(:h1, class: 'primary-heading') do
      h1_content = text
      h1_content += capture(&block) if block
      h1_content.html_safe
    end
  end

  
  def error_messages_for(object)
    render(partial: 'shared/error_messages', locals: { object: object })
  end
end