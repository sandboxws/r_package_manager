require 'dcf'

class SyncPackagesJob
  @queue = :sync_packages

    def self.perform
      url = AppBox.packages_cran_url
      response = HTTParty.get url
      if response.code == 200
        cran_packages = Dcf.parse response.body
        cran_packages.each do |p|
          Resque.enqueue ImportPackageJob, p
        end
      end
    end
end
