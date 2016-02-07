require 'rubygems/package'
require 'open-uri'
require 'fileutils'
require 'dcf'

class DownloadPackageMetaJob
  @queue = :download

  def self.perform(package_id)
    # {"Package"=>"xtable", "Version"=>"1.8-2", "Date"=>Fri, 08 Jan 2016, "Title"=>"Export Tables to LaTeX or HTML", "Author"=>"David B. Dahl <dahl@stat.byu.edu>", "Maintainer"=>"David Scott <d.scott@auckland.ac.nz>", "Imports"=>"stats, utils", "Suggests"=>"knitr, lsmeans, spdep, splm, sphet, plm, zoo, survival", "VignetteBuilder"=>"knitr", "Description"=>"Coerce data to LaTeX and HTML tables.", "URL"=>"http://xtable.r-forge.r-project.org/", "Depends"=>"R (>= 2.10.0)", "License"=>"GPL (>= 2)", "Repository"=>"CRAN", "NeedsCompilation"=>false, "Packaged"=>"2016-02-02 02:58:02 UTC; dsco036", "Date/Publication"=>2016-02-05 23:22:18 +0400}
    package = Package.find package_id
    # if !File.exist? "/tmp/#{package.head_version.filename}"
    file_path = "/tmp/#{package.head_version.filename}"

    open(file_path, 'wb') do |file|
      file << open(package.head_version.download_url).read
    end

    tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(file_path))
    tar_extract.rewind
    tar_extract.each do |entry|
      if entry.full_name == "#{package.name}/DESCRIPTION"
        contents = entry.read
        contents = contents.gsub /\: \n/, ''
        contents = contents.gsub /\n\s+/, ' '
        contents = contents.gsub /\'/, ''
        contents = contents.gsub /Date\/Publication/, 'Publication'

        spec = Dcf.parse contents
        if spec && spec.kind_of?(Array)
          spec = spec[0]

          package.description = spec['Description']
          package.url = spec['URL']

          version = package.versions.where(name: spec['Version']).first
          version.publish_date = spec['Publication']

          package.save
          version.save
        end
      end
    end
    tar_extract.close
    FileUtils.rm_rf "/tmp/#{package.head_version.filename}"
  end
end
