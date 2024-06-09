FactoryBot.define do
  factory :blog, class: 'Blog' do
    title { Faker::Creature::Animal.name }
    content { 'animals' }
  end
end