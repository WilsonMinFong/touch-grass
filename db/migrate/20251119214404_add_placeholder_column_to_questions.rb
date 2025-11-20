class AddPlaceholderColumnToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :placeholder, :text
  end
end
