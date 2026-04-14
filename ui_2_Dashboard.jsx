import React from 'react';

const Dashboard = () => {
  // These would eventually be fetched from your Spring Boot API
  const stats = [
    { name: 'Total Inventory Items', value: '1,284', change: '+12%', changeType: 'increase' },
    { name: 'Active Volunteers', value: '42', change: '5 today', changeType: 'info' },
    { name: 'Expiring Soon (7 days)', value: '18', change: 'Action Needed', changeType: 'decrease' },
    { name: 'Branches Active', value: '6', change: 'All Online', changeType: 'info' },
  ];

  return (
    <div className="flex h-screen bg-gray-100">
      {/* Sidebar */}
      <div className="w-64 bg-slate-900 text-white flex flex-col">
        <div className="p-6 text-2xl font-bold border-b border-slate-800">PrimaryFeed</div>
        <nav className="flex-1 p-4 space-y-2">
          <a href="#" className="block p-3 bg-blue-600 rounded-md">Dashboard</a>
          <a href="#" className="block p-3 hover:bg-slate-800 rounded-md">Operations</a>
          <a href="#" className="block p-3 hover:bg-slate-800 rounded-md">Community</a>
          <a href="/" className="block p-3 hover:bg-slate-800 rounded-md mt-10 text-gray-400">Logout</a>
        </nav>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-auto p-8">
        <header className="mb-8">
          <h1 className="text-2xl font-bold text-gray-800">System Overview</h1>
          <p className="text-gray-500 text-sm">Real-time data from primaryfeed_db</p>
        </header>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {stats.map((stat) => (
            <div key={stat.name} className="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
              <p className="text-sm font-medium text-gray-500">{stat.name}</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">{stat.value}</p>
              <p className={`text-xs mt-2 font-semibold ${
                stat.changeType === 'decrease' ? 'text-red-600' : 'text-green-600'
              }`}>
                {stat.change}
              </p>
            </div>
          ))}
        </div>

        {/* Data Tables Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Expiring Inventory - Derived from your vw_expiring_inventory */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="p-4 border-b border-gray-100 bg-gray-50 flex justify-between">
              <h3 className="font-bold text-gray-700 text-sm uppercase">Priority: Expiring Inventory</h3>
              <span className="text-xs text-red-500 font-bold">Query #12</span>
            </div>
            <table className="w-full text-left text-sm">
              <thead className="bg-gray-50 text-gray-600">
                <tr>
                  <th className="px-4 py-3 font-semibold">SKU</th>
                  <th className="px-4 py-3 font-semibold">Item</th>
                  <th className="px-4 py-3 font-semibold text-right">Qty</th>
                  <th className="px-4 py-3 font-semibold">Expiry</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                <tr>
                  <td className="px-4 py-3 font-mono">SKU-001</td>
                  <td className="px-4 py-3">Canned Chickpeas</td>
                  <td className="px-4 py-3 text-right">24</td>
                  <td className="px-4 py-3 text-red-600">2026-04-20</td>
                </tr>
                <tr>
                  <td className="px-4 py-3 font-mono">SKU-042</td>
                  <td className="px-4 py-3">Whole Wheat Bread</td>
                  <td className="px-4 py-3 text-right">110</td>
                  <td className="px-4 py-3 text-orange-600">2026-04-22</td>
                </tr>
              </tbody>
            </table>
          </div>

          {/* Volunteer Hours - Derived from your vw_volunteer_hours_log */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="p-4 border-b border-gray-100 bg-gray-50 flex justify-between">
              <h3 className="font-bold text-gray-700 text-sm uppercase">Recent Volunteer Impact</h3>
              <span className="text-xs text-blue-500 font-bold">Query #13</span>
            </div>
            <div className="p-6 text-center text-gray-400 italic">
               [ Chart Visualization: Hours per Branch ]
               <p className="text-xs mt-2 font-normal">Visualizing volunteer distribution across Boston/Lynn branches.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
