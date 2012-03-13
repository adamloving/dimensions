FactoryGirl.define do
  factory :entity do
    type  "location"
    serialized_data  "state" => "Colima"
  end
end
