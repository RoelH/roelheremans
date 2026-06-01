module ProfilHelper
  CANONICAL_BIO_SENTENCE = "Roel Heremans (1990, lives and works between Brussels and Stockholm) is an artist and keynote speaker working with sound, composed introspection, and neurotechnology, often through interactive systems shaped by video game culture.".freeze
  LEGACY_SPEAKING_INTRO_SENTENCES = [
    "Roel Heremans is a keynote speaker and transdigital artist whose talks examine how AI and neurotechnology are changing perception, attention and imagination."
  ].freeze
  LEADING_SPEAKING_INTRO_PATTERNS = [
    /\A#{Regexp.escape(CANONICAL_BIO_SENTENCE)}\s*/m,
    /\A(?:<(?:strong|b)>\s*)?Roel Heremans(?:\s*<\/(?:strong|b)>)? is a keynote speaker and transdigital artist whose talks examine how (?:AI and neurotechnology|neurotechnology and AI) are changing perception, attention,? and imagination\.\s*/im
  ].freeze

  def canonical_bio_sentence
    CANONICAL_BIO_SENTENCE
  end

  def speaking_body_without_canonical_intro(text)
    body = text.to_s.strip

    LEADING_SPEAKING_INTRO_PATTERNS.each do |pattern|
      body = body.sub(pattern, "")
    end

    body.strip
  end
end
