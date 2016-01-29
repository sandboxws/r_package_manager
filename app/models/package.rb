class Package
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :title, type: String
  field :description, type: String
  field :version, type: String
  field :publish_date, type: Date

  has_and_belongs_to_many :authors, class_name: 'Author'
  has_and_belongs_to_many :maintainers, class_name: 'Author'
end
