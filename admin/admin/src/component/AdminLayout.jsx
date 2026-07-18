import { useState } from "react";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import { useAdmin } from "./AdminProvider";

const navItems = [
  { to: "/dashboard", label: "Home", icon: "◈" },
  { to: "/dashboard/tournaments", label: "Add Tournament", icon: "🏆" },
  { to: "/dashboard/brackets", label: "Brackets", icon: "🎯" },
  { to: "/dashboard/live-control", label: "Live Video", icon: "▶" },
  { to: "/dashboard/highlights", label: "Highlights", icon: "✦" },
  { to: "/dashboard/shop", label: "Shop Control", icon: "🛍" },
];

export function AdminLayout({ children }) {
  const { admin, logout, settings } = useAdmin();
  const location = useLocation();
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate("/login", { replace: true });
    setIsOpen(false);
  };

  return (
    <div className="admin-shell">
      {isOpen && <div className="sidebar-overlay" onClick={() => setIsOpen(false)} />}
      
      <header className="mobile-header">
        <button className="mobile-menu-btn" onClick={() => setIsOpen(true)}>
          <span className="mobile-menu-btn__icon">☰</span>
        </button>
        <div className="mobile-header__brand">
          <div className="mobile-header__crest">GZ</div>
          <span className="mobile-header__title">{settings.brandName}</span>
        </div>
      </header>

      <aside className={`sidebar ${isOpen ? "sidebar--open" : ""}`}>
        <div className="sidebar__brand">
          <div className="sidebar__crest">GZ</div>
          <div style={{ flex: 1 }}>
            <p className="eyebrow">blue-white command center</p>
            <h1>{settings.brandName}</h1>
          </div>
          <button className="sidebar__close-btn" onClick={() => setIsOpen(false)}>
            ✕
          </button>
        </div>

        <nav className="sidebar__nav">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === "/dashboard"}
              onClick={() => setIsOpen(false)}
              className={({ isActive }) =>
                `nav-link${isActive ? " nav-link--active" : ""}`
              }
            >
              <span className="nav-link__icon">{item.icon}</span>
              <span>{item.label}</span>
            </NavLink>
          ))}
          <button
            type="button"
            className="nav-link logout-link"
            onClick={handleLogout}
          >
            <span className="nav-link__icon">🚪</span>
            <span>Logout</span>
          </button>
        </nav>

        <div className="sidebar__player-card">
          <div className="sidebar__player-glow" />
          <p className="eyebrow">signed in as</p>
          <h3>{admin.name}</h3>
          <p>{admin.role}</p>
          <button type="button" className="secondary-button" onClick={handleLogout}>
            Logout
          </button>
        </div>
      </aside>

      <main className="workspace">
        <header className="workspace__topbar">
          <div>
            <p className="eyebrow">current route</p>
            <h2>{navItems.find((item) => item.to === location.pathname)?.label || "Dashboard"}</h2>
          </div>
          <div className="workspace__spotlight">
            <span className="workspace__spotlight-dot" />
            {settings.dashboardHeadline}
          </div>
        </header>
        <section className="workspace__content">{children}</section>
      </main>
    </div>
  );
}
