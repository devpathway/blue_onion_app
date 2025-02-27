# Blue Onion Labs - Full-Stack Take Home Assignment

## **Project Overview**
This is a **Ruby on Rails + React.js** web application that aggregates and displays **monthly journal entries** based on provided **orders and payments CSV data**. The application follows **double-entry accounting principles**, ensuring that debits and credits are balanced.

## **Technologies Used**
- **Backend:** Ruby on Rails 8 (API mode)
- **Frontend:** React.js (Integrated via esbuild)
- **Database:** PostgreSQL
- **Bundler:** esbuild (instead of Webpacker)
- **Styling:** Bootstrap
- **Data Import:** CSV processing via Rake task

---

## **Installation and Setup**

### **1️⃣ Clone the Repository**
```sh
 git clone https://github.com/devpathway/blue_onion_app
 cd blue_onion_app
```

### **2️⃣ System Dependencies**
Ensure you have the following installed:
- **Ruby** `3.4.2`
- **PostgreSQL** `>= 12`
- **Node.js** `>= 16`
- **Yarn** `>= 1.22`
- **Bundler** `>= 2.3`

### **3️⃣ Install Dependencies**
#### **Backend (Rails)**
```sh
 bundle install
 rails db:create db:migrate
```

#### **Frontend (React + esbuild)**
```sh
 yarn install
```

### **4️⃣ Configuration**
Ensure you have the correct database settings in **config/database.yml**. If needed, copy the example file:
```sh
 cp config/database.example.yml config/database.yml
```
Then update your database credentials.

### **5️⃣ Database Initialization**
Run migrations and seed the database:
```sh
 rails db:migrate db:seed
```

### **6️⃣ Import Data from CSV**
Place the provided **data.csv** in the root directory, then run:
```sh
 rake csv:import_orders
```

### **7️⃣ How to Run the Application**
To run Rails and esbuild together, use:
```sh
 bin/dev
```
This will start the **Rails server** at `http://localhost:3000/` and the **esbuild watcher** for React.

---


## **How It Works**

### **Journal Entry Calculations**
Each journal entry aggregates transactions for a given month (`ordered_at` date). The following rules are applied:

- **Sales (Revenue)**
  - Debit → `Accounts Receivable`
  - Credit → `Revenue`
  
- **Shipping Fees**
  - Debit → `Accounts Receivable`
  - Credit → `Shipping Revenue`
  
- **Taxes**
  - Debit → `Accounts Receivable`
  - Credit → `Sales Tax Payable`
  
- **Payments Received**
  - Debit → `Cash`
  - Credit → `Accounts Receivable`

Each order's payments are **aggregated to prevent duplicate transactions**.

### **Database Schema**
- **Orders Table** (`orders`):
  - `order_id`, `ordered_at`, `item_type`, `price_per_item`, `quantity`, `shipping`, `tax_rate`
- **Payments Table** (`payments`):
  - `payment_id`, `order_id`, `payment_date`, `payment_amount`

### **API Endpoint**
The application exposes a **journal entries API**:
```
GET /api/v1/journal_entries?month=YYYY-MM
```
Example:
```
GET http://localhost:3000/api/v1/journal_entries?month=2023-01
```
Returns JSON-formatted journal entries.

---

## **Deployment Instructions**
To deploy the application:
1. **Precompile assets**
   ```sh
   rails assets:precompile
   ```
2. **Run database migrations**
   ```sh
   rails db:migrate
   ```
3. **Start the server**
   ```sh
   rails s -e production
   ```

For Heroku or Render deployment, follow platform-specific guides.

---

## **Design Decisions & Assumptions**
- **React Integrated with Rails**: Used **esbuild** (instead of Webpacker) for a modern and simple integration.
- **Data Aggregation**: Ensured all payments per order are summed up, so there are no duplicate transactions.
- **Date Filtering**: Used a `Date.strptime(month, "%Y-%m")` range query instead of `DATE_TRUNC` to ensure compatibility.
- **CSV Data Handling**: Implemented a **Rake task** to import orders and payments in bulk.
- **API-First Approach**: The frontend is fully decoupled and fetches data via an API.

---

## **Next Steps & Enhancements**
- **Deploy to Render/Fly.io** for hosting.
- **Unit Tests using RSpec** for API and data calculations.
- **Error Boundaries in React** for better error handling.
- **Add Filtering & Sorting** options in the UI.

---

Happy coding!

