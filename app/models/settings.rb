class Settings
  class << self
    attr_writer :filer_root

    def filer_root
      @filer_root || File.join(Rails.root, 'db', 'ftp')
    end

    def filer
      Uploader::Filer.new(filer_root)
    end

    def donations_info_url
      '/karoryfer-lecolds/informacje/darowizny'
    end

    def youtube_url
      'http://www.youtube.com/user/KaroryferLecolds'
    end

    def facebook_url
      'http://www.facebook.com/karoryfer'
    end

    def twitter_url
      'http://www.twitter.com/karoryfer'
    end

    def flattr_url
      'http://flattr.com/profile/karoryfer'
    end

    def gplus_url
      'https://plus.google.com/101590945458103175168'
    end

    def highlighted
      [
        {
          'title' => 'Sample',
          'reference' => 'karoryfer-samples'
        }, {
          'title' => 'O nas',
          'reference' => 'karoryfer-lecolds'
        }
      ]
    end
  end
end