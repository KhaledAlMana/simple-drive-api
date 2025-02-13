class Blobs < ActiveRecord::Migration[8.0]
  def change
    create_table :blob_aggregates, id: false do |t|
      t.string :id, primary_key: true, null: false, limit: 36
      t.string :key, null: false
      t.integer :byte_size, null: false, limit: 8
      t.string :checksum, null: false
      t.string :storage_type, null: false
      t.string :created_by_id, limit: 36
      t.string :updated_by_id, limit: 36
      t.string :deleted_by_id, limit: 36
      t.datetime :deleted_at
      t.timestamps

      t.index :key, unique: true
      t.index :storage_type
      t.index :deleted_at
      t.foreign_key :accounts, column: :created_by_id
      t.foreign_key :accounts, column: :updated_by_id
      t.foreign_key :accounts, column: :deleted_by_id
    end

    # Storage tables with common structure
    storage_tables = {
      s3_storages: [ :bucket, :key ],
      local_storages: [ :full_path ],
      ftp_storages: [ :path, :host ],
      db_storages: [ :data ]
    }

    storage_tables.each do |table, fields|
      create_table table, id: false do |t|
        t.string :id, primary_key: true, null: false, limit: 36
        t.string :blob_id, null: false, limit: 36
        t.string :created_by_id, limit: 36
        t.string :updated_by_id, limit: 36
        t.string :deleted_by_id, limit: 36
        t.datetime :deleted_at
        t.timestamps

        # Add specific fields for each storage type
        fields.each do |field|
          if field == :data
            t.binary field, null: false
          else
            t.string field, null: false
          end
        end

        # Common indexes and foreign keys
        t.index :blob_id, unique: true
        t.index :deleted_at
        t.foreign_key :blob_aggregates, column: :blob_id
        t.foreign_key :accounts, column: :created_by_id
        t.foreign_key :accounts, column: :updated_by_id
        t.foreign_key :accounts, column: :deleted_by_id
      end
    end
  end
end
