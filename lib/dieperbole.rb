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
    doc.css('p').each do |n|
      lines << n.to_html
    end
    lines
  end

  def unhyperbole
    cleaned = []
    paragraphs = get_paragraphs
    paragraphs.each do |sentences|
      sentences.each_index do |idx|
        cleaned.push unhyperbole_sentence(idx, sentences)
      end
    end
    cleaned.join(" ")
  end

  def unhyperbole_sentence(idx, sentences)
    s = sentences[idx]
    s.strip!

    # If there's a next sentence, and this isn't at the end of a paragraph:
    next_idx = idx + 1
    if sentences[next_idx] && !s.match(/<\/p>$/)
      # Eliminate "Will flibber flubber? Yes." collections.
      # Let's leave the rhetorical questions to the politicians.
      if s.match(/\?$/) && sentences[next_idx].length < 12 # Mike Magic.
        sentences[next_idx] = ''
        return ''
      end
    end  

    # Bounceable offences.
    return '' if s.match(/^I /)
    
    cleaned_content += '</p>'
  end

  def get_paragraphs
    paragraphs = []
    content.each do |p|
      paragraphs << get_sentences(p)
    end
    paragraphs
  end

  def get_sentences(paragraph)
    # The first .? is to help prevent incursions into HTML tags.
    # This is not a proper parser. Can you FEEL the hack? :)
    paragraph.scan(/(?:<p>|[\.\?]\s)[^\.\?]+?[\.\?](?:\s|\n)/m)
             .collect do |sentence|
               sentence.sub(/^<p>/, '</p><p>')   # Horrific
                       .sub(/^(<p>|[\.\?])/, '') # Strip the first block if needed.
                       .sub(/^<\/p>/, '')        # Truly horrific 
             end
  end

end

