ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'test.db')
)

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :publications, :force => true do |t|
      t.string :name
    end
    
    create_table :articles, :force => true do |t|
      t.references :publication
      t.string  :title
      t.integer :rating
      t.string :author
    end

    create_table :comments, :force => true do |t|
      t.references :article
      t.string  :data
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Publication < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  has_many :comments
  belongs_to :publication
end

class Comment < ActiveRecord::Base
  belongs_to :article
end

class NonModel
  attr_accessor :name
end