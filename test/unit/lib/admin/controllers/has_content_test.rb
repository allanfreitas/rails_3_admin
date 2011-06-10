require 'test_helper'

class Admin::HasContentMock < ApplicationController
  include Admin::Controllers::HasContent

  managable_content_ignore_namespace 'another'
  managable_content_for :body, :side
end

class Admin::HasContentTest < ActiveSupport::TestCase

  def setup
    @controller = Admin::HasContentMock.new

    @page = Factory(:page, :controller_path => @controller.controller_path)
    @content_body = Factory(:page_content, :page => @page, :key => 'body')
    @content_side = Factory(:page_content, :page => @page, :key => 'side')
    @page.reload
  end

  test 'should configure content types' do
    assert_equal [:body, :side], Admin::HasContentMock.managable_content_for
  end

  test 'should configure ignored namespace' do
    assert Admin::HasContentMock.managable_content_ignore_namespace.include?('another')
  end

  test 'should retrieve correct page content with helper' do
    assert_equal @page.title, @controller.managable_content_for(:title)
    assert_equal @page.description, @controller.managable_content_for(:description)
    assert_equal @page.keywords, @controller.managable_content_for(:keywords)
    assert_equal @page.updated_at, @controller.managable_content_for(:updated_at)
  end

  test 'should retrieve nil for non existent page' do
    @page.destroy
    assert_nil @controller.managable_content_for(:title)
  end

  test 'should retrieve correct content with helper' do
    assert_equal @content_body.content, @controller.managable_content_for(:body)
    assert_equal @content_side.content, @controller.managable_content_for(:side)
  end

  test 'should retrieve nil for invalid content' do
    assert_nil @controller.managable_content_for(:invalid)
  end
end
