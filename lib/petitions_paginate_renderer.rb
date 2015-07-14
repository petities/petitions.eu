class PetitionsPaginateRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

    def page_number(page)
      unless page == current_page
        link(page, page, rel: rel_value(page), class: 'navigation-bar-item')
      else
        tag(:a, page, class: 'navigation-bar-item active')
      end
    end

    # taken from will_paginate 2-3-stable branch
    # in 3.* this method gives NotImplementedError
    def url(page)
      page_one = page == 1
      unless @url_string and !page_one
        @url_params = {}
        # page links should preserve GET parameters
        stringified_merge @url_params, @template.params if @template.request.get?
        stringified_merge @url_params, @options[:params] if @options[:params]
        
        if complex = param_name.index(/[^\w-]/)
          page_param = parse_query_parameters("#{param_name}=#{page}")
          
          stringified_merge @url_params, page_param
        else
          @url_params[param_name] = page_one ? 1 : 2
        end

        url = @template.url_for(@url_params)
        return url if page_one
        
        if complex
          @url_string = url.sub(%r!((?:\?|&amp;)#{CGI.escape param_name}=)#{page}!, "\\1\0")
          return url
        else
          @url_string = url
          @url_params[param_name] = 3
          @template.url_for(@url_params).split(//).each_with_index do |char, i|
            if char == '3' and url[i, 1] == '2'
              @url_string[i] = "\0"
              break
            end
          end
        end
      end
      # finally!
      @url_string.sub "\0", page.to_s
    end

    def gap
      %(<span class="navigation-bar-item">...</span>)
    end

    def previous_or_next_page(page, text, classname)
      ''
    end

    def html_container(html)
      tag(:div, html, class: 'navigation-bar')
    end


    # method for url(page) method written above
    # also taken from 2-3-stable branch
    def stringified_merge(target, other)
      other.each do |key, value|
        key = key.to_s # this line is what it's all about!
        existing = target[key]

        if value.is_a?(Hash) and (existing.is_a?(Hash) or existing.nil?)
          stringified_merge(existing || (target[key] = {}), value)
        else
          target[key] = value
        end
      end
    end

end