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
    cleaned = []
    sentences = get_sentences
    sentences.each do |s|
      cleaned.push unhyperbole_sentence(s, sentences)
    end
    cleaned.join(" ")
  end

  def unhyperbole_sentence(sentence, sentences)
    s = sentence
    s.strip!

    # Bounceable offences.
    return '' if s.match(/^Yes/)
    return '' if s.match(/\?$/)
    return '' if s.match(/^I /)
    
    # Moderate offences.
    s.sub!(/^Yes, /, '')
    s.sub!(/^But /, 'However, ')

    s # TODO
  end

  def get_sentences
    content.scan(/[^\.?]+[\.?][\s]/m)
  end

end

