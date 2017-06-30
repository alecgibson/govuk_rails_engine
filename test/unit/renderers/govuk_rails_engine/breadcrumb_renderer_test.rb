require 'test_helper'

module GovukRailsEngine
  class BreadcrumbRendererTest < ActionView::TestCase
    describe '#render' do
      describe 'a content item with no parents' do
        let(:content_item) { valid_content_item('links' => {}) }

        it 'renders a link to the home page' do
          render BreadcrumbRenderer.render(content_item)
          assert_select '.govuk-breadcrumbs', 1
          assert_select 'ol li', 1
        end

        it 'renders data attributes for tracking' do
          render BreadcrumbRenderer.render(content_item)

          expected_tracking_options = {
            dimension28: '1',
            dimension29: 'Home',
          }

          assert_select '.govuk-breadcrumbs[data-module="track-click"]', 1
          assert_select 'ol li:first-child a[data-track-action="1"]', 1
          assert_select 'ol li:first-child a[data-track-label="/"]', 1
          assert_select 'ol li:first-child a[data-track-category="breadcrumbClicked"]', 1
          assert_select "ol li:first-child a[data-track-options='#{expected_tracking_options.to_json}']", 1
        end
      end

      describe 'a content item with 2 parents' do
        let(:content_item) do
          valid_content_item(
            'links' => {
              'parent' => [
                'title' => 'Parent',
                'base_path' => '/parent',
                'content_id' => '7ee35d54-5a71-4fc3-9618-0f4f94322937',
                'locale' => 'en',
                'links' => {
                  'parent' => [
                    'title' => 'Grandparent',
                    'base_path' => '/grandparent',
                    'content_id' => '7ee35d54-5a71-4fc3-9618-0f4f94322937',
                    'locale' => 'en',
                  ]
                },
              ]
            }
          )
        end

        it 'tracks the total breadcrumb count on each breadcrumb' do
          render BreadcrumbRenderer.render(content_item)

          expected_tracking_options = [
            { dimension28: '3', dimension29: 'Home'},
            { dimension28: '3', dimension29: 'Grandparent'},
            { dimension28: '3', dimension29: 'Parent'},
          ]

          assert_select "ol li:nth-child(1) a[data-track-options='#{expected_tracking_options[0].to_json}']", 1
          assert_select "ol li:nth-child(2) a[data-track-options='#{expected_tracking_options[1].to_json}']", 1
          assert_select "ol li:nth-child(3) a[data-track-options='#{expected_tracking_options[2].to_json}']", 1
        end

        it 'renders a list of breadcrumbs' do
          render BreadcrumbRenderer.render(content_item)

          assert_link_with_text_in('ol li:nth-child(1)', '/', 'Home')
          assert_link_with_text_in('ol li:nth-child(2)', '/grandparent', 'Grandparent')
          assert_link_with_text_in('ol li:nth-child(3)', '/parent', 'Parent')
        end
      end
    end

    def valid_content_item(content_item)
      generator = GovukSchemas::RandomExample.for_schema(frontend_schema: "placeholder")
      generator.merge_and_validate(content_item)
    end

    def assert_link_with_text_in(selector, link, text)
      assert_select "#{selector} a[href=\"#{link}\"]", text: text
    end
  end
end
