# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    parent_id nil
    author { FactoryGirl.create(:user) }
    sequence :body do
      Faker::Lorem.paragraph
    end
    link { FactoryGirl.create(:link) }

    factory :child_comment do
      parent { FactoryGirl.create(:comment) }
    end
  end

end
