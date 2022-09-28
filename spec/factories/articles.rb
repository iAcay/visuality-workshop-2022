FactoryBot.define do
  factory :article do
    title { "A Title #{SecureRandom.hex(3)}" }
    content { 'Some Content' }
  end
end
