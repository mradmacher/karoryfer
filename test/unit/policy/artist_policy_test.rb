require 'test_helper'

class ArtistPolicyTest < ActiveSupport::TestCase
  def test_accessing_artist_resources_as_guest_is_allowed
    user = User.new
    artist = Artist.new
    assert ArtistPolicy.new(user).read?(artist)
    assert PagePolicy.new(user).read?(Page.new(artist: artist))
  end

  def test_managing_artist_resources_as_guest_is_denied
    user = User.new
    artist = Artist.new
    refute ArtistPolicy.new(user).write?(artist)
    refute PagePolicy.new(user).write?(Page.new(artist: artist))
  end

  def test_managing_artist_resources_as_admin_is_denied
    user = User.new(admin: true)
    artist = Artist.new
    refute ArtistPolicy.new(user).write?(artist)
    refute PagePolicy.new(user).write?(Page.new(artist: artist))
  end

  def test_managing_artist_resources_as_artist_member_is_allowed
    membership = Membership.sham!
    user = membership.user
    artist = membership.artist
    assert ArtistPolicy.new(user).write?(artist)
    assert PagePolicy.new(user).write?(Page.new(artist: artist))
  end

  def test_visitor_has_read_but_not_write_access
    policy = ArtistPolicy.new(User.new)
    assert policy.read_access?
    refute policy.write_access?
  end

  def test_member_has_read_and_write_access
    policy = ArtistPolicy.new(User.sham!)
    assert policy.read_access?
    assert policy.write_access?
  end
end
