CompanySearch::Application.routes.draw do
  get "company/index"
  root to: "company#index"
  get 'companies/org_number', to: 'companies#org_number'
end
