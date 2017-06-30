module GovukRailsEngine
  class BreadcrumbRenderer
    def self.render(content_item)
      breadcrumb_presenter =
        BreadcrumbPresenter.new(ContentItem.new(content_item), collapse_on_mobile: false)

      {
        template: 'govuk_component/breadcrumbs',
        locals: {
          breadcrumbs: breadcrumb_presenter.breadcrumbs,
          collapse_on_mobile_css_class: nil
        }
      }
    end
  end
end
