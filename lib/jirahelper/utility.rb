# Helper functions for lita-jira
module JiraHelper
  # Utility helpers
  module Utility
    def get_email(user)
      return nil unless user_stored?(user)
      redis.get(normalize_user(user))
    end

    def user_stored?(user)
      redis.exists(normalize_user(user))
    end

    def store_user!(user, email)
      return false if user_stored?(user)
      redis.set(normalize_user(user), email)
    end

    def delete_user!(user)
      return false unless user_stored?(user)
      redis.del(normalize_user(user))
    end

    def normalize_user(user)
      "user_#{user.id}"
    end
  end
end
