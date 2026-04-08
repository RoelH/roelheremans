class AddSpeakingToVideos < ActiveRecord::Migration[7.1]
  INITIAL_SPEAKING_VIDEO_URL = "https://www.youtube.com/watch?v=9JarXpuCASg"

  def up
    add_reference :videos, :speaking, foreign_key: true unless column_exists?(:videos, :speaking_id)
    change_column_null :videos, :work_id, true

    speaking_id = select_value("SELECT id FROM speakings ORDER BY id ASC LIMIT 1")

    unless speaking_id
      execute <<~SQL.squish
        INSERT INTO speakings (slug, created_at, updated_at)
        VALUES ('speaking', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
      speaking_id = select_value("SELECT id FROM speakings ORDER BY id ASC LIMIT 1")
    end

    existing_video_id = select_value(<<~SQL.squish)
      SELECT id
      FROM videos
      WHERE speaking_id = #{speaking_id.to_i}
        AND url = #{quote(INITIAL_SPEAKING_VIDEO_URL)}
      LIMIT 1
    SQL

    return if existing_video_id

    execute <<~SQL.squish
      INSERT INTO videos (url, speaking_id, cover, created_at, updated_at)
      VALUES (#{quote(INITIAL_SPEAKING_VIDEO_URL)}, #{speaking_id.to_i}, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    SQL
  end

  def down
    execute <<~SQL.squish
      DELETE FROM videos
      WHERE speaking_id IS NOT NULL
        AND url = #{quote(INITIAL_SPEAKING_VIDEO_URL)}
    SQL

    remove_reference :videos, :speaking, foreign_key: true if column_exists?(:videos, :speaking_id)
    change_column_null :videos, :work_id, false
  end
end
