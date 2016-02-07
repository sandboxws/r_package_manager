class ImportPackageJob
  @queue = :packages

    def self.perform(spec)
      if spec.is_a? Hash
        package = Package.import_from_spec spec
        if package.persisted? and package.description.nil?
          Resque.enqueue DownloadPackageMetaJob, package.id
        end
      end
    end
end
