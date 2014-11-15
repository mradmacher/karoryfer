module ResourcesControllerTest
  module DeleteDestroy
    def test_delete_destroy_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        delete :destroy, id: resource_class.sham!.to_param
      end
    end

    def test_delete_destroy_for_artist_user_properly_redirects
      membership = login_artist_user
      resource = resource_class.sham!( artist: membership.artist )
      delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
      assert_redirected_to send( "artist_#{resource_name.pluralize}_path",  resource.artist )
    end
  end
end
