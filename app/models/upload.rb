class Upload < ActiveRecord::Base
  belongs_to  :user, class_name: 'User'

  scope :negation,          -> (scope){ where(scope.where_values.reduce(:and).not) }

  scope :active,            -> { where status: :active }
  scope :recently_uploaded, -> { where arel_table[:created_at].gt(-15.minute.from_now) }
  scope :parentless,        -> { where num_refs: 0 }
  scope :with_user,         -> (user) { where user_id: user.id }

  scope :assignable,        -> (user) { active.recently_uploaded.parentless.with_user(user) }
  scope :trash,             -> { negation(recently_uploaded).parentless.active }

  validates_with AttachmentSizeValidator, :attributes => :resource, :less_than => 5.megabytes

  has_attached_file :resource,
                    storage:      :s3,
                    bucket:       S3['bucket'],
                    path:         '/resources/:updated_at/:hash.:extension',
                    hash_secret:  S3['hash_secret']
                    Proc.new{ |a| a.instance.s3_credentials }

  def s3_credentials
    {
      access_key_id:      S3['access_key_id'],
      secret_access_key:  S3['secret_access_key']
    }
  end

  def resource_url
    resource.url
  end

  def inc_num_refs
    Upload.increment_counter(:num_refs, id)
  end

  def dec_num_refs
    Upload.decrement_counter(:num_refs, id)
  end
end
