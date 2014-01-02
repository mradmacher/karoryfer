require 'test_helper'
require_relative 'resources_controller_test/get_index'
require_relative 'resources_controller_test/get_drafts'
require_relative 'resources_controller_test/get_show'
require_relative 'resources_controller_test/get_show_draft'
require_relative 'resources_controller_test/get_edit'
require_relative 'resources_controller_test/get_new'
require_relative 'resources_controller_test/put_update'
require_relative 'resources_controller_test/post_create'
require_relative 'resources_controller_test/delete_destroy'

class PagesControllerTest < ActionController::TestCase
  #include ResourcesControllerTest::GetIndex
  #include ResourcesControllerTest::GetDrafts
  include ResourcesControllerTest::GetShow
  #include ResourcesControllerTest::GetShowDraft
  include ResourcesControllerTest::GetEdit
  include ResourcesControllerTest::GetNew
  include ResourcesControllerTest::PutUpdate
  include ResourcesControllerTest::PostCreate
  include ResourcesControllerTest::DeleteDestroy

  def resource_name
    'page'
  end

  def resource_class
    Page
  end

  def test_get_edit_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    post = Post.sham!( artist: membership.artist )
    get :edit, :artist_id => post.artist.to_param, :id => post.to_param
    assert_select 'form' do
      assert_select 'input[type=hidden][name=?]', 'page[artist_id]'
      assert_select 'label', I18n.t( 'helpers.label.page.title' )
      assert_select 'input[type=text][name=?][value=?]', 'page[title]', page.title
      assert_select 'label', I18n.t( 'helpers.label.page.reference' )
      assert_select 'input[type=text][name=?][value=?][disabled=disabled]', 'page[reference]', page.reference
      assert_select 'label', I18n.t( 'helpers.label.page.content' )
      assert_select 'textarea[name=?]', 'page[content]', page.content
      assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
    end
  end

  def test_get_new_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    get :new
    assert_select 'form' do
      assert_select 'input[type=hidden][name=?]', 'page[artist_id]'
      assert_select 'label', I18n.t( 'helpers.label.page.title' )
      assert_select 'input[type=text][name=?]', 'page[title]'
      assert_select 'label', I18n.t( 'helpers.label.page.reference' )
      assert_select 'input[type=text][name=?][disabled=disabled]', 'page[reference]', 0
      assert_select 'input[type=text][name=?]', 'page[reference]'
      assert_select 'label', I18n.t( 'helpers.label.page.content' )
      assert_select 'textarea[name=?]', 'page[content]'
      assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
    end
  end
end
