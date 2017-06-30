Rails.application.routes.draw do
  mount GovukRailsEngine::Engine => "/govuk_rails_engine"
end
