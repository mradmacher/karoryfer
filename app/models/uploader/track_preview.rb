module Uploader
  class TrackPreview < CarrierWave::Uploader::Base
    cattr_accessor :store_dir

    def store_dir
      File.join(@@store_dir, (model.id / 100).to_s)
    end

    def filename
      "#{model.id}.#{file.extension}" if original_filename
    end
  end
end
