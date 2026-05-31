module ProfilHelper
  CANONICAL_BIO_SENTENCE = "Roel Heremans (1990, lives and works between Brussels and Stockholm) is an artist and keynote speaker working with sound, composed introspection, and neurotechnology, often through interactive systems shaped by video game culture.".freeze
  LEGACY_SPEAKING_INTRO_SENTENCES = [
    "Roel Heremans is a keynote speaker and transdigital artist whose talks examine how AI and neurotechnology are changing perception, attention and imagination."
  ].freeze

  def canonical_bio_sentence
    CANONICAL_BIO_SENTENCE
  end

  def speaking_body_without_canonical_intro(text)
    body = text.to_s.strip

    ([CANONICAL_BIO_SENTENCE] + LEGACY_SPEAKING_INTRO_SENTENCES).each do |sentence|
      body = body.sub(/\A#{Regexp.escape(sentence)}\s*/m, "")
    end

    body
  end
end
