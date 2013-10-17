# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    title "MyString"
    url "http://www.MyString.com"
    submitter { FactoryGirl.create(:user) }
  end
end
