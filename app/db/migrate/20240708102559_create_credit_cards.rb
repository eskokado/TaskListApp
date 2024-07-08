class CreateCreditCards < ActiveRecord::Migration[7.1]
  def change
    create_table :credit_cards do |t|
      t.references :subscription, null: false, foreign_key: true
      t.string :card_number

      t.timestamps
    end
  end
end
