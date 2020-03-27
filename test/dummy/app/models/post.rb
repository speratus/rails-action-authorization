class Post < ApplicationRecord
  belongs_to :user

  define_rule 'posts#show' do |p, u|
    p.user == u
  end

  define_rule 'posts#index' do |p, u|
    !u.nil?
  end
end
