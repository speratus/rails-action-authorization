class Post < ApplicationRecord
  belongs_to :user

  define_rule 'posts#show' do |p, u|
    p.user == u
  end
end
