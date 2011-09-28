require 'rubygems'
require 'open-uri'
require 'nokogiri'

class Unhyperbole

  attr_accessor :content

  def initialize(raw_content)
    self.content = get_cleaned_content(raw_content)
  end

  def get_cleaned_content(raw_content)
    # Crudely strip out module-crunchbase onwards, because the
    # content isn't nested in anything.
    raw_content.sub!(/<div class="module-crunchbase">.*/m, '')

    doc = Nokogiri::HTML(raw_content)
    doc.css('blockquote p').each do |p|
      p['class'] = 'blockquote'
    end
    
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
      cleaned << '<p>'
      sentences.each_index do |idx|
        cleaned << unhyperbole_sentence(idx, sentences)
      end
      cleaned << '</p>'
    end
    cleaned.join(" ")
  end

  def unhyperbole_sentence(idx, sentences)
    s = sentences[idx]    
    s.strip!
    
    return '' if s.empty?
    
    tag_regex = '(?:<[a-zA-Z]+(?: [a-zA-Z-]+="[^"]+">)*)?'

    # If there's a next sentence (and this isn't at the end of a paragraph):
    next_idx = idx + 1
    if sentences[next_idx]
      # Eliminate "Will flibber flubber? Yes." collections.
      # Let's leave the rhetorical questions to the politicians.
      if s.match(/\?$/) && sentences[next_idx].length < 30 # Mike Magic.
        sentences[next_idx] = ''
        return ''
      end

      # Again with conjunctions beginning sentences.
      if !s.index('and') && sentences[next_idx].match(/^#{tag_regex}And /)
        s = s[0..-2] + ' ' + sentences[next_idx][0, 1].downcase + sentences[next_idx][1..-1]
        sentences[next_idx] = ''
      end
    end    
        
    # Get rid of sentences that have three words or less in them.
    words = s.split(' ');
    return '' if words.length < 4
    
    # You may love it but we don't.
    return '' if s.match(/^#{tag_regex}I love /)
    
    # That's great but we'll make the decision on that one.
    return '' if s.match(/^They are the real deal./)
    
    # No sentence needs to begin with 'Yes'.
    s.sub!(/^#{tag_regex}Yes, /, '')
    
    # But's a conjunctive. What you mean is 'However'.
    s.sub!(/^#{tag_regex}But /, 'However, ')
    
    # That'll do.
    s[0].capitalize + s[1..-1]
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
    sentences = []
    offset = 0
    while offset < paragraph.length
      # Horrifying.
      m = paragraph.match(/(.+?((?:\.|\?|!)(?:\s|&#822.;)|<\/p>))/m, offset)
      break unless m

      # Truly horrifying.
      sentence = m[0].strip
                     .sub(/^<p>/, '')
                     .sub(/<\/p>$/, '')

      # Add it to the pile.
      sentences << sentence

      # .offset returns [start, end] - take the
      # end and use it as the new offset.
      offset = m.offset(0)[1]
    end
    sentences
  end

end

