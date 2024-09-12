class AddCommunityIdToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :community, null: true, foreign_key: true

    # 既存の投稿に対して、特定のデフォルトコミュニティを設定する
    Post.update_all(community_id: Community.first.id) if Community.any?

    # その後、NOT NULL 制約を追加する
    change_column_null :posts, :community_id, false
  end
end
