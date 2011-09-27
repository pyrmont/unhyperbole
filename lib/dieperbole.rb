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
    dieperbolic_sentences = []
    hyperbolic_sentences = get_sentences
    length = hyperbolic_sentences.length
    
    # Initialise our sentences to false.
    prev_s = false
    this_s = false
    next_s = false
    
    for i in 0...length do
      
      prev_s = this_s
      this_s = (next_s) ? next_s : hyperbolic_sentence[i]
      next_s = (i == (length - 1)) ? false : hyperbolic_sentences[i+1]

      # This was just a paragraph break or it's an empty string. Push it on and then skip to the next sentence.
      if this_s == false || this_s == ''
        dieperbolic_sentences push this_s
        next
      end

      # No sentence needs to begin with 'Yes'.
      this_s.sub!(/^Yes, /, '')
      
      # But's a conjunctive. What you mean is 'However'.
      this_s.sub!(/^But /, 'However, ')
      
      # Let's leave the rhetorical questions to the politicians.
      if this_s.match!(/\?$/)
        if next_s && next_s.length < 12 # Change this magic value
          this_s = ''
          next_s = ''
      end
      
      # Solve that I disease problem.
      this_s.sub!(/^I /)
      
      # Again with conjunctions beginning sentences.
      if next_s && next_s.match(/^And /)
        this_s = this_s + ' ' + next_s[0, 1].downcase + next_s[1..-1]
        next_s = ''
      end
      
      dieperbolic_sentences.push this_s
    end    

    cleaned_content = '<p>'

    dieperbolic_sentences.each do |sentence|
      if sentence || sentence != ''
        cleaned_content += '' + sentence
      elsif sentence
        cleaned_content += '</p>'
      end
    end
    
    cleaned_content += '</p>'
  end

  def get_sentences
    # The first .? is to help prevent incursions into HTML tags.
    # This is not a proper parser. Can you FEEL the hack? :)
    content.scan(/(?:<p>|[\.?]\s)[^\.?]+?[\.?]\s/m)
           .collect{ |s| s.sub(/^[\.?]/, '') } # Strip the first char if needed.
  end

end

