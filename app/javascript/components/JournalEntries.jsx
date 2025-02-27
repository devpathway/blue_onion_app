import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom/client";
import axios from "axios";

const JournalEntries = () => {
  const [month, setMonth] = useState("2023-01");
  const [journalEntries, setJournalEntries] = useState([]);

  useEffect(() => {
    axios
      .get(`/api/v1/journal_entries?month=${month}`)
      .then((response) => setJournalEntries(response.data))
      .catch((error) => console.error("Error fetching journal entries:", error));
  }, [month]);

  return (
    <div className="container mt-4">
      <h1>Journal Entries</h1>
      <label>Select Month: </label>
      <input type="month" value={month} onChange={(e) => setMonth(e.target.value)} />
      <table className="table table-bordered mt-3">
        <thead>
          <tr>
            <th>Account</th>
            <th>Debit</th>
            <th>Credit</th>
          </tr>
        </thead>
        <tbody>
          {journalEntries.map((entry, index) =>
            entry.entries.map((line, idx) => (
              <tr key={`${index}-${idx}`}>
                <td>{line.account}</td>
                <td>${Number(line.debit || 0).toFixed(2)}</td>
                <td>${Number(line.credit || 0).toFixed(2)}</td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
};

// Mount React inside Rails
const rootElement = document.getElementById("react-root");

if (rootElement) {
  const root = ReactDOM.createRoot(rootElement);
  root.render(<JournalEntries />);
}

export default JournalEntries;
