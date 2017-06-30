module GovukRailsEngine
  module ApplicationHelper
    def parent_layout(layout_name)
      render file: "layouts/govuk_rails_engine/#{layout_name}.html.erb", layout: 'layouts/govuk_template'
    end
  end
end
