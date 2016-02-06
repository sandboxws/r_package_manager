class Package
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  is_impressionable

  field :name, type: String
  field :title, type: String
  field :description, type: String
  field :downloads, type: Integer, default: 0

  slug :name

  has_many :versions, dependent: :destroy
  has_and_belongs_to_many :authors, class_name: 'Author'
  has_and_belongs_to_many :maintainers, class_name: 'Author'

  def self.import_from_spec(spec)
    package = Package.find_or_create_by name: spec['Package']
    package.title = package.name
    package.save

    package.add_version! spec
  end

  def add_version!(spec)
    if !has_version?(spec['Version'])
      self.versions << Version.build_from_spec(spec, self)
      self.save
    end
  end

  def has_version?(version_name)
    self.versions.collect(&:name).include?(version_name)
  end

  def head_version
    self.versions.last
  end
end
