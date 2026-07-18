
import {
  Navigate,
  Outlet,
  Route,
  Routes,
} from "react-router-dom";

import { AdminLayout } from "./component/AdminLayout";
import { AdminProvider, useAdmin } from "./component/AdminProvider";

import {
  DashboardPage,
  HighlightsPage,
  LiveControlPage,
  LoginPage,
  ShopPage,
  TournamentsPage,
} from "./component/pages.jsx";
import { BracketPage } from "./component/BracketPage";

function ProtectedShell() {
  const { isAuthenticated } = useAdmin();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  return (
    <AdminLayout>
      <Outlet />
    </AdminLayout>
  );
}

function PublicLogin() {
  const { isAuthenticated } = useAdmin();

  if (isAuthenticated) {
    return <Navigate to="/dashboard" replace />;
  }

  return <LoginPage />;
}

export default function App() {
  return (
    <AdminProvider>
      <Routes>
        <Route path="/" element={<PublicLogin />} />
        <Route path="/login" element={<PublicLogin />} />
        <Route path="/brackets" element={<BracketPage />} />

        <Route element={<ProtectedShell />}>
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route
            path="/dashboard/tournaments"
            element={<TournamentsPage />}
          />
          <Route
            path="/dashboard/brackets"
            element={<BracketPage />}
          />
          <Route
            path="/dashboard/live-control"
            element={<LiveControlPage />}
          />
          <Route
            path="/dashboard/highlights"
            element={<HighlightsPage />}
          />
          <Route path="/dashboard/shop" element={<ShopPage />} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </AdminProvider>
  );
}

