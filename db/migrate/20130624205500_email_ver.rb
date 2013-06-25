class EmailVer < ActiveRecord::Migration
  def change
     add_column :users, :was_email_verified, :boolean, :default => false 
     add_column :users, :email_verification_token, :string 
   end
end
