ActiveRecord::Schema.define(:version => 1) do
  create_table "publications", :force => true do |t|
    t.string "name", "subdomain"
  end

  create_table "articles", :force => true do |t|
    t.references 'publication'
    t.string 'title'
  end
end

class Publication < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :publication
end