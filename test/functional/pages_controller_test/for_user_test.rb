require 'test_helper'

module PagesControllerTest
  class ForUserTest < ActionController::TestCase
    def setup
      @controller = PagesController.new
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    def test_get_show_does_not_display_actions
      page = Page.sham!
      get :show, :id => page.to_param
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', new_page_path, 0
      assert_select 'a[href=?]', edit_page_path( page ), 0
      assert_select 'a[href=?][data-method=delete]', page_path( page ), 0
    end

    def test_get_edit_is_denied
      assert_raises CanCan::AccessDenied do
        get :edit, :id => Page.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises CanCan::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises CanCan::AccessDenied do
        put :update, :id => Page.sham!.to_param, :page => {}
      end
    end

    def test_post_create_is_denied
      assert_raises CanCan::AccessDenied do
        post :create, :page => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises CanCan::AccessDenied do
        delete :destroy, :id => Page.sham!.to_param
      end
    end
  end
end

