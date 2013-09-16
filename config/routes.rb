CompanySearch::Application.routes.draw do
  get "company/index"
  root to: "company#index"
end
