class CreateStatusTransitions < ActiveRecord::Migration
  def change
    create_table :status_transitions do |t|
      t.references :order, index: true
      t.string :event
      t.string :from
      t.string :to
      t.text :reason

      t.timestamps
    end
  end
end
