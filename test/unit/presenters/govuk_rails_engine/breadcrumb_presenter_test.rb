require 'test_helper'

module GovukRailsEngine
  class BreadcrumbPresenterTest < ActiveSupport::TestCase
    describe "#breadcrumbs" do
      it "can handle any valid content item" do
        generator = GovukSchemas::RandomExample.for_schema(frontend_schema: "placeholder")
        content_item = ContentItem.new(generator.payload)
        BreadcrumbPresenter.new(content_item).breadcrumbs
      end

      it "returns the root when parent is not specified" do
        content_item = {"links" => {}}
        breadcrumbs = breadcrumbs_for(content_item)

        breadcrumbs.must_equal(
          [
            CrumbPresenter.new(title: 'Home', url: '/'),
          ],
        )
      end

      it "returns the root when parent is empty" do
        content_item = content_item_with_parents([])
        breadcrumbs = breadcrumbs_for(content_item)

        breadcrumbs.must_equal(
          [
            CrumbPresenter.new(title: 'Home', url: '/'),
          ],
        )
      end

      it "places parent under the root when there is a parent" do
        parent = {
          "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
          "locale" => "en",
          "title" => "A-parent",
          "base_path" => "/a-parent",
        }

        content_item = content_item_with_parents([parent])
        breadcrumbs = breadcrumbs_for(content_item)

        breadcrumbs.must_equal(
          [
            CrumbPresenter.new(title: 'Home', url: '/'),
            CrumbPresenter.new(title: 'A-parent', url: '/a-parent'),
          ],
        )
      end

      it "includes grandparent when available" do
        grandparent = {
          "title" => "Another-parent",
          "base_path" => "/another-parent",
          "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
          "locale" => "en",
        }

        parent = {
          "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
          "locale" => "en",
          "title" => "A-parent",
          "base_path" => "/a-parent",
          "links" => {
            "parent" => [grandparent]
          }
        }

        content_item = content_item_with_parents([parent])
        breadcrumbs = breadcrumbs_for(content_item)

        breadcrumbs.must_equal(
          [
            CrumbPresenter.new(title: 'Home', url: '/'),
            CrumbPresenter.new(title: 'Another-parent', url: '/another-parent'),
            CrumbPresenter.new(title: 'A-parent', url: '/a-parent'),
          ]
        )
      end
    end

    def content_item_with_parents(parents)
      {
        "links" => {"parent" => parents}
      }
    end

    def breadcrumbs_for(content_item)
      generator = GovukSchemas::RandomExample.for_schema(frontend_schema: "placeholder")
      fully_valid_content_item = ContentItem.new(
        generator.merge_and_validate(content_item))

      # Use the main class instead of GovukNavigationHelpers::Breadcrumbs, so that
      # we're testing both at the same time.
      BreadcrumbPresenter.new(fully_valid_content_item).breadcrumbs
    end
  end
end
