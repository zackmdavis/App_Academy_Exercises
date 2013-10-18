# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub do
    sequence :name do |n|
      Faker::Commerce.department
    end
    mod_id 1
  end
end
