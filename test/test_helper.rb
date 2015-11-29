ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'sequel'
require 'shams'

dbconfig = Rails.configuration.database_configuration['test']
DB = Sequel.connect("postgres://#{dbconfig['username']}:#{dbconfig['password']}@localhost/#{dbconfig['database']}")
FIXTURES_DIR = File.expand_path('../fixtures', __FILE__)

module I18n
  def self.raise_missing_translation(*args)
    puts args.first
    puts args.first.class
    fail args.first.to_exception
  end
end
I18n.exception_handler = :raise_missing_translation

Uploader::Release.store_dir = '/tmp'
Attachment::Uploader.store_dir = '/tmp'
Uploader::TrackSource.store_dir = '/tmp'
Uploader::TrackPreview.store_dir = '/tmp'
Publisher.instance.name = 'Lecolds'
Publisher.instance.url = 'http://www.lecolds.com'

class ActiveSupport::TestCase
  class TestAbility
    attr_accessor :scope

    def initialize
      @allowed = []
    end

    def allow(action, subject)
      @allowed << [action, subject]
    end

    def allow?(action, subject)
      @allowed.detect { |e| (e[0] == action) && (e[1] == subject) }
    end

    alias_method :allows?, :allow?
  end

  def with_permission_to(action, subject)
    abilities = TestAbility.new
    abilities.allow(action, subject)
    yield abilities
  end

  def without_permissions
    yield TestAbility.new
  end

  DEFAULT_TITLE = 'Karoryfer Lecolds'
  TITLE_SEPARATOR = ' - '

  def build_title(*args)
    args << DEFAULT_TITLE
    args.join TITLE_SEPARATOR
  end

  def assert_headers(h1, h2 = nil, h3 = nil)
    assert_select 'h1', h1
    assert_select 'h2', h2 unless h2.nil?
    assert_select 'h3', h3 unless h3.nil?
  end

  def assert_title(*args)
    assert_select 'title', build_title(args)
  end

  def login(user)
    activate_authlogic
    UserSession.create user
  end

  def login_user
    user = User.sham!
    login(user)
    user
  end

  def login_admin
    user = User.sham!(:admin)
    login(user)
    user
  end

  def login_artist_user
    membership = Membership.sham!
    login(membership.user)
    membership
  end

  def allow(action, subject)
    activate_authlogic
    unless @controller.abilities.class == TestAbility
      @controller.abilities = TestAbility.new
    end
    @controller.abilities.allow(action, subject)
  end

  def deny(_, _)
    activate_authlogic
    @controller.abilities = TestAbility.new
  end

  def assert_authorized(action, subject, &block)
    activate_authlogic
    @controller.abilities = TestAbility.new
    assert_raises User::AccessDenied do
      block.call
    end
    @controller.abilities.allow(action, subject)
    assert_nothing_raised User::AccessDenied do
      block.call
    end
  end
end
