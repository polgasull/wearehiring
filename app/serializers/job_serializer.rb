class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :avatar, :location, :company, :remote_ok, :salary_from, :salary_to, :slug, :reference, :expiry_date, :created_at, :inscriptions

  belongs_to :category
  belongs_to :job_type
  belongs_to :level
  has_many :skills

  def inscriptions
    object.inscriptions.all.count
  end

  def company
    object.job_author
  end

  def expiry_date
    object.expiry_date.strftime("%F")
  end

  def created_at
    object.created_at.strftime("%F")
  end
end
