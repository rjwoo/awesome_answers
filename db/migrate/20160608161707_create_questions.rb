# migrations are used to change the structure of the database
# For Example:
# Creating tables
# Dropping tables
# Adding columns to tables
# Removing columns from tables
# Adding indexes
# Removing indexes
class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body

      t.timestamps null: false
    end
  end
end
