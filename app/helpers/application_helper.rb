# frozen_string_literal: true

module ApplicationHelper
  def display_meta_tags
    content_for(:meta_tags)
  end

  def add_meta_tags(**meta_tags)
    content_for :meta_tags do
      meta_tags.each do |name, content|
        concat(tag.meta(name: name, content: content))
      end
    end
  end
end
