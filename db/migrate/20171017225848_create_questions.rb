class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.text :content, :null => false
      t.string :year, :null => false
      t.string :source, :null => false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
