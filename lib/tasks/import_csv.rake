namespace :csv do
  desc "Import orders from CSV"
  task import_orders: :environment do
    file_path = Rails.root.join("./data.csv") # Update this with the correct path
    CsvImportService.import_orders(file_path)
    puts "Orders and payments imported successfully!"
  end
end
