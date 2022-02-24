FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 10) }
  end

  factory :post do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 50) }
  end

  factory :comment do
    comment { Faker::Lorem.characters(number: 50) }
  end

  factory :tweet do
    tweet { Faker::Lorem.characters(number: 50) }
  end

  factory :creator_note do
    comment { Faker::Lorem.characters(number: 50) }
  end

  factory :relationship do
  end

  factory :bookmark do
  end

  factory :favorite do
  end
end
