class ImportPackageJob
  @queue = :packages

    def self.perform(spec)
      # {"Package"=>"ABHgenotypeR", "Version"=>"1.0.0", "Imports"=>"ggplot2, reshape2", "Suggests"=>"knitr, rmarkdown", "License"=>"GPL-3", "NeedsCompilation"=>false}
      # spec = {"Package"=>"A3", "Version"=>"1.0.1", "Depends"=>"R (>= 2.15.0), xtable, pbapply", "Suggests"=>"randomForest, e1071", "License"=>"GPL (>= 2)", "NeedsCompilation"=>false}
      Package.import_from_spec spec if spec.is_a? Hash
    end
end
