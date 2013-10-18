# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    sequence :title do
      Faker::Commerce.product_name
    end
    sequence :url do
      Faker::Internet.url
    end
    sub { FactoryGirl.create(:sub) }
    submitter { FactoryGirl.create(:user) }
  end
end
