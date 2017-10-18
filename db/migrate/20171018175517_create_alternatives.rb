class CreateAlternatives < ActiveRecord::Migration[5.1]
  def change
    create_table :alternatives do |t|
      t.text :content, :null => false 
      t.boolean :correct, :default => false
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
