class RenameVatCodeByHand < ActiveRecord::Migration
  def change
    change_table :customers do |t|
      t.rename :vat_core, :vat_code
    end
  end
end
