require "test_helper"

class ProfilControllerTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = []
  self.fixture_sets = {}

  test "home and about pages publish person structured data" do
    Profil.create!(
      about: "About marker",
      pic_url: "https://example.com/about.jpg"
    )

    [root_path, about_path].each do |path|
      get path

      assert_response :success
      assert_select "link[rel='me'][href='https://www.wikidata.org/wiki/Q140002789']"
      schema = Nokogiri::HTML(response.body).at_css("script[type='application/ld+json']")
      assert schema.present?
      assert_includes schema.text, "https://www.wikidata.org/wiki/Q140002789"
    end
  end

  test "speaking page publishes honest metadata and person structured data" do
    Speaking.create!(
      text: "#{ProfilHelper::LEGACY_SPEAKING_INTRO_SENTENCES.first} His presentations and workshops help audiences think clearly.",
      pic_url: "https://example.com/portrait.jpg"
    )

    get speaking_path

    assert_response :success
    assert_select "title", ApplicationHelper::DEFAULT_META_TITLE
    assert_select "meta[name='description'][content=?]", ApplicationHelper::DEFAULT_META_DESCRIPTION
    assert_select "link[rel='me'][href='https://www.wikidata.org/wiki/Q140002789']"
    assert_select "a[href='https://www.wikidata.org/wiki/Q140002789'][rel='me']", false

    document = Nokogiri::HTML(response.body)
    schema = document.at_css("script[type='application/ld+json']")
    assert schema.present?
    assert_includes schema.text, "https://www.wikidata.org/wiki/Q140002789"
    assert_includes schema.text, "Neurotechnology Artist"
    assert_includes schema.text, "Keynote Speaker"

    first_body_sentence = document.at_css(".paragraph p")&.text
    assert_equal ProfilHelper::CANONICAL_BIO_SENTENCE, first_body_sentence
    assert_not_includes response.body, ProfilHelper::LEGACY_SPEAKING_INTRO_SENTENCES.first
  end

  test "speaking page places logos between portrait and content" do
    speaking = Speaking.create!(
      text: "Speaking body marker",
      pic_url: "https://example.com/portrait.jpg"
    )

    logo = speaking.speaking_logos.build(
      name: "Example Institution",
      alt_text: "Example Institution logo",
      destination_url: "https://example.com",
      image_url: "https://res.cloudinary.com/dmbutdgsi/image/upload/v1777464448/mentalprivacy_29_04_26_14_07_27.png",
      position: 1,
      active: true
    )
    logo.save!

    speaking.videos.create!(
      url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    )

    get speaking_path

    assert_response :success

    body = response.body
    portrait_index = body.index("portrait.jpg")
    logos_index = body.index("speaking-logos")
    text_index = body.index("Speaking body marker")
    video_index = body.index("www.youtube-nocookie.com/embed/dQw4w9WgXcQ")

    assert portrait_index.present?
    assert logos_index.present?
    assert_includes body, "https://res.cloudinary.com/dmbutdgsi/image/upload/f_auto,q_auto,w_320/v1777464448/mentalprivacy_29_04_26_14_07_27.png"
    assert text_index.present?
    assert video_index.present?
    assert_operator portrait_index, :<, logos_index
    assert_operator logos_index, :<, text_index
    assert_operator text_index, :<, video_index
  end
end
