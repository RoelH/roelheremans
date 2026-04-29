require "test_helper"
require "stringio"

class ProfilControllerTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = []
  self.fixture_sets = {}

  test "speaking page places logos between portrait and content" do
    speaking = Speaking.create!(
      text: "Speaking body marker",
      pic_url: "https://example.com/portrait.jpg"
    )

    logo = speaking.speaking_logos.build(
      name: "Example Institution",
      alt_text: "Example Institution logo",
      destination_url: "https://example.com",
      position: 1,
      active: true
    )
    logo.image.attach(
      io: StringIO.new("logo"),
      filename: "example-logo.png",
      content_type: "image/png"
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
    assert text_index.present?
    assert video_index.present?
    assert_operator portrait_index, :<, logos_index
    assert_operator logos_index, :<, text_index
    assert_operator text_index, :<, video_index
  end
end
