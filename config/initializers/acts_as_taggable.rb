ActsAsTaggableOn::Tag.include_root_in_json = false
module ActsAsTaggableOn
  class Tag
    def blacklist!
      self.update_attribute(:blacklisted, true)
    end
  end
end
