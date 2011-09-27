require 'rubygems'
require 'open-uri'
require 'nokogiri'

class Dieperbole

  attr_accessor :content

  def initialize(raw_content)
    self.content = get_cleaned_content(raw_content)
  end

  def get_cleaned_content(raw_content)
    # Crudely strip out module-crunchbase onwards, because the
    # content isn't nested in anything.
    raw_content.sub!(/<div class="module-crunchbase">.*/m, '')

    doc = Nokogiri::HTML(raw_content)
    lines = []
    doc.xpath('//p').to_html
  end

  def unhyperbole
#    cleaned = []
#    sentences = get_sentences
#    sentences.each do |s|
#      cleaned.push unhyperbole_sentence(s, sentences)
#    end
#    cleaned.join(" ")
    
    
    sentences = get_sentences
    length = sentences.length
    for i in 0...length do
      prev_s = (i == 0) ? false : sentence[i-1]
      this_s = sentence[i]
      next_s = (i == (sentences))

      # No sentence needs to begin with 'Yes'.
      this_s.sub!(/^Yes, /, '')
      
      # Let's leave the rhetorical questions to the politicians.
      if this_s.match!(/\?$/)
        if next_s.length != '' || next_s.length < 5
          
      end
      # return '' if this_s.match(/^Yes/)
      # return '' if this_s.match(/\?$/)
      # return '' if this_s.match(/^I /)
    end
    
    
    
  end

  def unhyperbole_sentence(sentence, sentences)
    s = sentence
    s.strip!

    # Bounceable offences.
    return '' if s.match(/\?$/)
    return '' if s.match(/^I /)
    
    # Moderate offences.
    s.sub!(/^Yes, /, '')
    s.sub!(/^But /, 'However, ')

    # Ok, that'll do.
    s
  end

  def get_sentences
    # The first .? is to help prevent incursions into HTML tags.
    # This is not a proper parser. Can you FEEL the hack? :)
    content.scan(/(?:<p>|[\.?]\s)[^\.?]+?[\.?]\s/m)
           .collect{ |s| s.sub(/^[\.?]/, '') } # Strip the first char if needed.
  end

end

