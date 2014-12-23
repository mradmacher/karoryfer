require 'test_helper'

# Tests for post resource.
class PostResourceTest < ActiveSupport::TestCase
  def test_resource_class_is_post
    resource = Resource::PostResource.new(Ability.new(nil), {})
    assert_equal Post, resource.resource_class
  end

  def test_permits_all_allowed_params
    permitted_params = {
      title: 1,
      body: 1
    }
    rejected_params = {
      dummy: 1
    }
    params = { post: permitted_params.merge(rejected_params) }

    resource = Resource::PostResource.new(Ability.new(nil), params)
    permitted_params.keys.each do |p|
      assert resource.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute resource.permitted_params.include?(p)
    end
  end
end