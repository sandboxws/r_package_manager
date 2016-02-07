class Version
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  field :publish_date, type: String
  field :r_version, type: String
  field :downloads, type: Integer
  field :dependencies, type: Array, default: []
  field :suggestions, type: Array, default: []
  field :imports, type: Array, default: []

  belongs_to :package

  def self.build_from_spec(spec, package)
    version = Version.new
    version.name = spec['Version']

    if spec['Depends']
      depends = spec['Depends'].split ','
      depends.each do |d|
        d.strip!
        if d.match /^R \(/
          version.r_version = d
        elsif !version.dependencies.include?(d)
          version.dependencies << d
        end
      end
    end

    if spec['Suggests']
      suggests = spec['Suggests'].split ','
      suggests.each do |s|
        s.strip!
        if !version.suggestions.include?(s)
          version.suggestions << s
        end
      end
    end

    if spec['Imports']
      imports = spec['Imports'].split ','
      imports.each do |i|
        i.strip!
        if !version.imports.include?(i)
          version.imports << i
        end
      end
    end

    version.package = package

    version
  end

  def download_url
    # Download url format: http://cran.r­project.org/src/contrib/[PACKAGE_NAME]_[PACKAGE_VERSION].tar.gz
    "http://cran.r-project.org/src/contrib/#{filename}"
  end

  def filename
    "#{self.package.name}_#{name}.tar.gz"
  end
end
