class AddCharToPiece < ActiveRecord::Migration[5.0]
  def change
  	add_column :pieces, :representation, :string
  	add_column :pieces, :color, :string
  	add_index :pieces, :representation, unique: true
  end
end
