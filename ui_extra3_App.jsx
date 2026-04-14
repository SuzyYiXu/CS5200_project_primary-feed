import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

// Import the components we designed
import LoginPage from './LoginPage';
import Dashboard from './Dashboard';
import OperationsPortal from './OperationsPortal';
import CommunityManagement from './CommunityManagement';

import './App.css';

function App() {
  return (
    <Router>
      <Routes>
        {/* Public Route */}
        <Route path="/login" element={<LoginPage />} />
        
        {/* Private Routes (The pages that show after login) */}
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/operations" element={<OperationsPortal />} />
        <Route path="/community" element={<CommunityManagement />} />

        {/* Default redirect: send user to Login if they go to the root URL */}
        <Route path="/" element={<Navigate to="/login" replace />} />
      </Routes>
    </Router>
  );
}

export default App;
