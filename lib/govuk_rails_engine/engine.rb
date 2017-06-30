require 'govuk_template'

module GovukRailsEngine
  class Engine < ::Rails::Engine
    isolate_namespace GovukRailsEngine

    config.to_prepare do
      Rails.application.config.assets.precompile += %w(
        govuk_rails_engine/favicon.ico
        govuk_rails_engine/*.js
        govuk_rails_engine/static.css
        govuk_rails_engine/static-ie*.css
        govuk_rails_engine/fonts*.css
        govuk_rails_engine/guides-print.css
        govuk_rails_engine/header-footer-only*.css
        govuk_rails_engine/core-layout*.css
        govuk_rails_engine/static-print.css
      )
    end
  end
end
