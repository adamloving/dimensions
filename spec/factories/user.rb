FactoryGirl.define do
  factory :user do

  end

  factory :admin_user do
    email     "admin@example.com"
    password  "password"
  end
end
