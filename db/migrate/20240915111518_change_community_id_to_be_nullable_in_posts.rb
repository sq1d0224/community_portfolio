class ChangeCommunityIdToBeNullableInPosts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :posts, :community_id, true
  end
end
