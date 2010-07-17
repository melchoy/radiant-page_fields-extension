module PageMetaExtension::MetaTags
  include Radiant::Taggable

  desc %{
    The namespace for 'meta' attributes.  If used as a singleton tag, both the description
    and keywords fields will be output as &lt;meta /&gt; tags unless the attribute 'tag' is set to 'false'.

    *Usage:*

    <pre><code> <r:meta [tag="false"] />
     <r:meta>
       <r:description [tag="false"] />
       <r:keywords [tag="false"] />
     </r:meta>
    </code></pre>
  }
  tag 'meta' do |tag|
    if tag.double?
      tag.expand
    else
      if !tag.attr['name'].blank?
        return '' unless name = assign_local_meta!(tag)
        show_tag = tag.attr['tag'] != 'false' || false
        description = CGI.escapeHTML(tag.locals.meta.content)
        if show_tag
          %{<meta name="#{name}" content="#{description}" />}
        else
          description
        end
      else
        ActiveSupport::Deprecation.warn("Using r:meta without a `name' attribute is deprecated. Please use r:meta name='Meta Attribute' instead.", caller)
        tag.render('description', tag.attr) +
        tag.render('keywords', tag.attr)
      end
    end
  end

  def assign_local_meta!(tag)
    return if tag.attr['name'].blank?
    tag.locals.meta = tag.locals.page.meta[tag.attr['name']]
    tag.attr['name'].downcase
  end

  desc %{
    Emits the page description field in a meta tag, unless attribute
    'tag' is set to 'false'.

    *Usage:*

    <pre><code> <r:meta:description [tag="false"] /> </code></pre>
  }
  tag 'meta:description' do |tag|
    ActiveSupport::Deprecation.warn('r:meta:description is deprecated. Please use r:meta name="Description" instead.', caller)
    show_tag = tag.attr['tag'] != 'false' || false
    description = CGI.escapeHTML(tag.locals.page.meta['Description'].try :content)
    if show_tag
      "<meta name=\"description\" content=\"#{description}\" />"
    else
      description
    end
  end

  desc %{
    Emits the page keywords field in a meta tag, unless attribute
    'tag' is set to 'false'.

    *Usage:*

    <pre><code> <r:meta:keywords [tag="false"] /> </code></pre>
  }
  tag 'meta:keywords' do |tag|
    ActiveSupport::Deprecation.warn('r:meta:keywords is deprecated. Please use r:meta name="Keywords" instead.', caller)
    show_tag = tag.attr['tag'] != 'false' || false
    keywords = CGI.escapeHTML(tag.locals.page.meta['Keywords'].try :content)
    if show_tag
      "<meta name=\"keywords\" content=\"#{keywords}\" />"
    else
      keywords
    end
  end

end