import { useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAdmin } from "./AdminProvider";
import { DataTable, Field, MetricCard, PageIntro, Panel, StatusBadge } from "./ui";

const BRACKET_OPTIONS = [
  { value: 64, label: "64 Players", entryLabel: "Top 64" },
  { value: 128, label: "128 Players", entryLabel: "Top 128" },
];

export function LoginPage() {
  const { login, settings } = useAdmin();
  const navigate = useNavigate();
  const [form, setForm] = useState({
    email: "",
    password: "",
  });
  const [error, setError] = useState("");

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");

    const success = await login(form);

    if (!success) {
      setError("Invalid credentials. Use the configured admin email and password.");
      return;
    }

    navigate("/dashboard");
  };

  return (
    <div className="login-screen">
      <div className="login-card">
        <div className="login-card__hero">
          <p className="eyebrow">Pakistan eSports League inspired palette</p>
          <h1>{settings.brandName}</h1>
          <p>{settings.loginHeadline}</p>
          <div className="login-card__badge-row">
            <span className="hero-chip">Live Tournaments</span>
            <span className="hero-chip">Shop Control</span>
            <span className="hero-chip">Champion Stories</span>
          </div>
          <div className="login-card__glow-ring" />
        </div>

        <form className="login-form" autoComplete="off" onSubmit={handleSubmit}>
          <h2>Admin Login</h2>
          <p className="login-form__hint">
            Use the backend admin account credentials to sign in and manage tournaments.
          </p>
          <Field label="Email">
            <input
              type="email"
              name="admin-email"
              autoComplete="off"
              value={form.email}
              onChange={(event) =>
                setForm((current) => ({ ...current, email: event.target.value }))
              }
              placeholder="admin@genzesports.com"
            />
          </Field>
          <Field label="Password">
            <input
              type="password"
              name="admin-password"
              autoComplete="new-password"
              value={form.password}
              onChange={(event) =>
                setForm((current) => ({
                  ...current,
                  password: event.target.value,
                }))
              }
              placeholder="Enter password"
            />
          </Field>
          {error ? <div className="form-error">{error}</div> : null}
          <button className="primary-button" type="submit">
            Enter Control Room
          </button>
        </form>
      </div>
    </div>
  );
}

export function DashboardPage() {
  const { tournaments, liveVideos, highlights, products } =
    useAdmin();

  const metrics = [
    {
      label: "Tournaments",
      value: tournaments.length,
      note: `${tournaments.filter((item) => item.status === "Live").length} live now`,
    },
    {
      label: "Live streams",
      value: liveVideos.length,
      note: `${liveVideos.filter((item) => item.status === "Live").length} actively broadcasting`,
    },
    {
      label: "Shop products",
      value: products.length,
      note: `${products.filter((item) => item.featured).length} featured`,
    },
  ];

  return (
    <div className="page-grid">
      <PageIntro
        title="Admin Home"
        description="A fast command view for tournaments, streams, highlights, and shop activity."
      />

      <div className="metrics-grid">
        {metrics.map((metric) => (
          <MetricCard key={metric.label} {...metric} />
        ))}
      </div>

      <div className="two-column-grid">
        <Panel
          title="Tournament pulse"
          subtitle="Latest competitions prepared from the app-ready tournament structure."
        >
          {tournaments.slice(0, 3).map((item) => (
            <div className="list-card" key={item.id}>
              <div>
                <strong>{item.title}</strong>
                <p>
                  {item.game} • {item.schedule}
                </p>
              </div>
              <StatusBadge value={item.status} />
            </div>
          ))}
        </Panel>

        <Panel
          title="Live media control"
          subtitle="Streams and highlights currently available to the app."
        >
          {[...liveVideos.slice(0, 2), ...highlights.slice(0, 1)].map((item) => (
            <div className="media-tile" key={item.id}>
              <img src={item.thumbnail} alt={item.title} />
              <div>
                <strong>{item.title}</strong>
                <p>{item.streamer || item.category}</p>
              </div>
            </div>
          ))}
        </Panel>
      </div>
    </div>
  );
}

export function TournamentsPage() {
  const { tournaments, addTournament, updateTournament, deleteTournament, cycleTournamentStatus } = useAdmin();

  const [form, setForm] = useState({
    title: "",
    game: "FC 25",
    status: "Upcoming",
    schedule: "",
    prize: "",
    attendance: "",
    actionText: "Register",
  });
  const [imageFile, setImageFile] = useState(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [editingId, setEditingId] = useState(null);

  const submit = async (event) => {
    event.preventDefault();
    setErrorMessage("");
    setSuccessMessage("");

    try {
      if (editingId) {
        await updateTournament(editingId, form, imageFile);
        setSuccessMessage("Tournament updated successfully.");
        setEditingId(null);
      } else {
        await addTournament(form, imageFile);
        setSuccessMessage("Tournament added successfully.");
      }
      setForm({
        title: "",
        game: "FC 25",
        status: "Upcoming",
        schedule: "",
        prize: "",
        actionText: "Register",
      });
      setImageFile(null);
    } catch (error) {
      setErrorMessage(error.message || "Unable to save tournament.");
    }
  };

  return (
    <div className="page-grid">
      <PageIntro
        title="Tournament Control"
        description="Create and update tournaments using fields aligned with the mobile app cards."
      />
      <div className="two-column-grid two-column-grid--form">
        <Panel title={editingId ? "Edit Tournament" : "Add Tournament"} subtitle="Title, schedule, prize, attendance, stream, and CTA">
          <form className="stack-form" onSubmit={submit}>
            <Field label="Tournament Title">
              <input
                value={form.title}
                onChange={(event) => setForm({ ...form, title: event.target.value })}
                placeholder="Karachi Open Qualifier"
                required
              />
            </Field>
            <Field label="Game">
              <select
                value={form.game}
                onChange={(event) => setForm({ ...form, game: event.target.value })}
              >
                <option>FC 25</option>
                <option>Tekken 8</option>
                <option>Valorant</option>
                <option>PubG Mobile</option>
              </select>
            </Field>
            <Field label="Status">
              <select
                value={form.status}
                onChange={(event) => setForm({ ...form, status: event.target.value })}
              >
                <option>Upcoming</option>
                <option>Live</option>
                <option>Completed</option>
              </select>
            </Field>
            <Field label="Schedule">
              <input
                value={form.schedule}
                onChange={(event) => setForm({ ...form, schedule: event.target.value })}
                placeholder="2026-06-01 20:00"
                required
              />
            </Field>
            <div className="form-split">
              <Field label="Prize Pool">
                <input
                  value={form.prize}
                  onChange={(event) => setForm({ ...form, prize: event.target.value })}
                  placeholder="$2,500"
                  required
                />
              </Field>
              <Field label="Attendance">
                <input
                  value={form.attendance}
                  onChange={(event) => setForm({ ...form, attendance: event.target.value })}
                  placeholder="48 / 64 Players"
                  required
                />
              </Field>
            </div>
            <Field label="Background Image">
              <input
                type="file"
                accept="image/*"
                onChange={(event) => setImageFile(event.target.files?.[0] ?? null)}
              />
            </Field>
            <Field label="Action Button">
              <input
                value={form.actionText}
                onChange={(event) => setForm({ ...form, actionText: event.target.value })}
                placeholder="Register"
                required
              />
            </Field>
            {errorMessage ? <p className="form-error">{errorMessage}</p> : null}
            {successMessage ? <p className="form-success">{successMessage}</p> : null}
            <div className="form-actions">
              <button className="primary-button" type="submit">
                {editingId ? 'Update Tournament' : 'Save Tournament'}
              </button>
              {editingId ? (
                <button
                  type="button"
                  className="ghost-button"
                  onClick={() => {
                    setEditingId(null);
                    setForm({
                      title: "",
                      game: "FC 25",
                      status: "Upcoming",
                      schedule: "",
                      prize: "",
                      actionText: "Register",
                    });
                    setImageFile(null);
                  }}
                >
                  Cancel Edit
                </button>
              ) : null}
            </div>
          </form>
        </Panel>

        <Panel title="Tournament List" subtitle="Click status to cycle upcoming, live, and completed">
          <DataTable
            columns={["Event", "Game", "Prize", "Attendance", "Status", "Actions"]}
            rows={tournaments}
            renderRow={(item) => (
              <div className="table-row" key={item.id}>
                <div>
                  <strong>{item.title}</strong>
                  <span>{item.schedule}</span>
                </div>
                <span>{item.game}</span>
                <span>{item.prize}</span>
                <span>{item.attendance}</span>
                <button
                  className="ghost-pill"
                  onClick={() => cycleTournamentStatus(item.id)}
                >
                  <StatusBadge value={item.status} />
                </button>
                <div className="table-actions">
                  <button
                    className="ghost-button"
                    onClick={() => {
                      setEditingId(item.id);
                      setForm({
                        title: item.title || "",
                        game: item.game || "FC 25",
                        status: item.status || "Upcoming",
                        schedule: item.schedule || "",
                        prize: item.prize || "",
                        attendance: item.attendance || "",
                        actionText: item.actionText || "Register",
                      });
                      setImageFile(null);
                      window.scrollTo({ top: 0, behavior: 'smooth' });
                    }}
                  >
                    Edit
                  </button>
                  <button
                    className="danger-button"
                    onClick={async () => {
                      if (!window.confirm('Delete this tournament?')) return;
                      try {
                        await deleteTournament(item.id);
                        setSuccessMessage('Tournament deleted');
                      } catch (err) {
                        setErrorMessage(err.message || 'Unable to delete tournament');
                      }
                    }}
                  >
                    Delete
                  </button>
                </div>
              </div>
            )}
          />
        </Panel>
      </div>
    </div>
  );
}

export function LiveControlPage() {
  const { liveVideos, addLiveVideo, updateLiveVideo, deleteMediaItem } = useAdmin();
  const [errorMessage, setErrorMessage] = useState("");
  const [editingId, setEditingId] = useState("");
  const [form, setForm] = useState({
    title: "",
    streamer: "",
    status: "Live",
    embedUrl: "",
  });

  const isEditing = editingId !== "";

  const resetForm = () => {
    setErrorMessage("");
    setEditingId("");
    setForm({
      title: "",
      streamer: "",
      status: "Live",
      embedUrl: "",
    });
  };

  return (
    <div className="page-grid">
      <PageIntro
        title="Live Video Control"
        description="Manage live embeds, thumbnails, caster info, and stream state for the app."
      />
      <div className="two-column-grid two-column-grid--form">
        <Panel title="Add Stream" subtitle="Live video, matchday stream, or desk feed">
          <form
            className="stack-form"
            onSubmit={async (event) => {
              event.preventDefault();
              setErrorMessage("");
              try {
                if (isEditing) {
                  await updateLiveVideo(editingId, form);
                } else {
                  await addLiveVideo(form);
                }
                resetForm();
              } catch (error) {
                setErrorMessage(error.message || "Unable to save live video.");
              }
            }}
          >
            <Field label="Title">
              <input
                value={form.title}
                onChange={(event) => setForm({ ...form, title: event.target.value })}
                placeholder="Main Stage Stream"
                required
              />
            </Field>
            <Field label="Streamer / Desk">
              <input
                value={form.streamer}
                onChange={(event) =>
                  setForm({ ...form, streamer: event.target.value })
                }
                placeholder="Arena Desk"
                required
              />
            </Field>
            <Field label="Status">
              <select
                value={form.status}
                onChange={(event) => setForm({ ...form, status: event.target.value })}
              >
                <option>Live</option>
                <option>Scheduled</option>
                <option>Offline</option>
              </select>
            </Field>
            <Field label="Embed URL">
              <input
                value={form.embedUrl}
                onChange={(event) =>
                  setForm({ ...form, embedUrl: event.target.value })
                }
                placeholder="https://www.youtube.com/embed/..."
                required
              />
            </Field>
            <div className="form-actions">
              <button className="primary-button" type="submit">
                {isEditing ? "Update Live Feed" : "Publish Live Feed"}
              </button>
              {isEditing ? (
                <button
                  className="secondary-button"
                  type="button"
                  onClick={resetForm}
                >
                  Cancel Edit
                </button>
              ) : null}
            </div>
            {errorMessage ? <p className="form-error">{errorMessage}</p> : null}
          </form>
        </Panel>
        <Panel title="Current Feeds" subtitle="Preview active and scheduled broadcasts">
          <div className="media-grid">
            {liveVideos.map((item) => (
              <div className="media-card" key={item.id}>
                <img src={item.thumbnail} alt={item.title} />
                <div className="media-card__body">
                  <StatusBadge value={item.status} />
                  <strong>{item.title}</strong>
                  <p>{item.streamer}</p>
                  <div className="media-card__actions">
                    <button
                      className="secondary-button"
                      onClick={() => {
                        setEditingId(item.id);
                        setForm({
                          title: item.title || "",
                          streamer: item.streamer || "",
                          status: item.status || "Live",
                          embedUrl: item.embedUrl || "",
                        });
                      }}
                    >
                      Edit
                    </button>
                    <button
                      className="secondary-button"
                      onClick={async () => {
                        try {
                          await deleteMediaItem(item.id);
                          if (editingId === item.id) {
                            resetForm();
                          }
                        } catch (error) {
                          setErrorMessage(error.message || "Unable to delete feed.");
                        }
                      }}
                    >
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Panel>
      </div>
    </div>
  );
}

export function HighlightsPage() {
  const { highlights, addHighlight, updateHighlight, deleteMediaItem } = useAdmin();
  const [errorMessage, setErrorMessage] = useState("");
  const [editingId, setEditingId] = useState("");
  const [form, setForm] = useState({
    title: "",
    category: "Player Story",
    published: "",
    videoUrl: "",
  });

  const isEditing = editingId !== "";

  const resetForm = () => {
    setErrorMessage("");
    setEditingId("");
    setForm({
      title: "",
      category: "Player Story",
      published: "",
      videoUrl: "",
    });
  };

  return (
    <div className="page-grid">
      <PageIntro
        title="Highlights Library"
        description="Upload highlight metadata, champion posters, top plays, and story-led videos."
      />
      <div className="two-column-grid two-column-grid--form">
        <Panel title="Add Highlight" subtitle="For reels, player edits, and recap drops">
          <form
            className="stack-form"
            onSubmit={async (event) => {
              event.preventDefault();
              setErrorMessage("");
              try {
                if (isEditing) {
                  await updateHighlight(editingId, form);
                } else {
                  await addHighlight(form);
                }
                resetForm();
              } catch (error) {
                setErrorMessage(error.message || "Unable to save highlight.");
              }
            }}
          >
            <Field label="Highlight Title">
              <input
                value={form.title}
                onChange={(event) => setForm({ ...form, title: event.target.value })}
                placeholder="Areeb Rehman Championship Run"
                required
              />
            </Field>
            <Field label="Category">
              <select
                value={form.category}
                onChange={(event) =>
                  setForm({ ...form, category: event.target.value })
                }
              >
                <option>Player Story</option>
                <option>FC 25</option>
                <option>Tekken 8</option>
                <option>Tournament Recap</option>
              </select>
            </Field>
            <Field label="Published Date">
              <input
                value={form.published}
                onChange={(event) =>
                  setForm({ ...form, published: event.target.value })
                }
                placeholder="2026-05-24"
                required
              />
            </Field>
            <Field label="Embed URL">
              <input
                value={form.videoUrl}
                onChange={(event) =>
                  setForm({ ...form, videoUrl: event.target.value })
                }
                placeholder="https://www.youtube.com/embed/..."
                required
              />
            </Field>
            <div className="form-actions">
              <button className="primary-button" type="submit">
                {isEditing ? "Update Highlight" : "Add Highlight"}
              </button>
              {isEditing ? (
                <button
                  className="secondary-button"
                  type="button"
                  onClick={resetForm}
                >
                  Cancel Edit
                </button>
              ) : null}
            </div>
            {errorMessage ? <p className="form-error">{errorMessage}</p> : null}
          </form>
        </Panel>
        <Panel title="Published Highlights" subtitle="Poster-like champion stories and match reels">
          <div className="media-grid">
            {highlights.map((item) => (
              <div className="media-card" key={item.id}>
                <img src={item.thumbnail} alt={item.title} />
                <div className="media-card__body">
                  <StatusBadge value={item.category} />
                  <strong>{item.title}</strong>
                  <p>{item.published}</p>
                  <div className="media-card__actions">
                    <button
                      className="secondary-button"
                      onClick={() => {
                        setEditingId(item.id);
                        setForm({
                          title: item.title || "",
                          category: item.category || "Player Story",
                          published: item.published || "",
                          videoUrl: item.videoUrl || item.embedUrl || "",
                        });
                      }}
                    >
                      Edit
                    </button>
                    <button
                      className="secondary-button"
                      onClick={async () => {
                        try {
                          await deleteMediaItem(item.id);
                          if (editingId === item.id) {
                            resetForm();
                          }
                        } catch (error) {
                          setErrorMessage(error.message || "Unable to delete highlight.");
                        }
                      }}
                    >
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Panel>
      </div>
    </div>
  );
}

export function ShopPage() {
  const { products, addProduct, updateProduct, deleteProduct, toggleFeatureProduct } = useAdmin();
  const [query, setQuery] = useState("");
  const [editingId, setEditingId] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const [form, setForm] = useState({
    name: "",
    category: "Controllers",
    price: "",
    inventory: "",
    imageUrl: "",
    imageData: "",
    imageType: "",
    featured: false,
  });

  const deferredQuery = query.toLowerCase().trim();
  const filteredProducts = useMemo(
    () =>
      products.filter((product) =>
        `${product.name} ${product.category}`.toLowerCase().includes(deferredQuery),
      ),
    [deferredQuery, products],
  );

  const isEditing = editingId !== "";

  const resetForm = () => {
    setErrorMessage("");
    setEditingId("");
    setForm({
      name: "",
      category: "Controllers",
      price: "",
      inventory: "",
      imageUrl: "",
      imageData: "",
      imageType: "",
      featured: false,
    });
  };

  const handleFileChange = (event) => {
    const file = event.target.files && event.target.files[0];
    if (!file) {
      return;
    }

    const reader = new FileReader();
    reader.onload = () => {
      const result = reader.result;
      if (typeof result === 'string') {
        const base64 = result.split(',')[1] ?? '';
        setForm((current) => ({
          ...current,
          imageUrl: result,
          imageData: base64,
          imageType: file.type,
        }));
      }
    };
    reader.readAsDataURL(file);
  };

  return (
    <div className="page-grid">
      <PageIntro
        title="Shop Control"
        description="Manage product cards, categories, inventory, pricing, and featured merchandising."
        action={
          <input
            className="search-input"
            value={query}
            onChange={(event) => setQuery(event.target.value)}
            placeholder="Search products"
          />
        }
      />
      <div className="two-column-grid two-column-grid--form">
        <Panel title="Add Product" subtitle="The same catalog powers your app storefront">
          <form
            className="stack-form"
            onSubmit={async (event) => {
              event.preventDefault();
              setErrorMessage("");
              try {
                const payload = {
                  ...form,
                  price: Number(form.price),
                  inventory: Number(form.inventory),
                };

                if (isEditing) {
                  await updateProduct(editingId, payload);
                } else {
                  await addProduct(payload);
                }

                resetForm();
              } catch (error) {
                setErrorMessage(error.message || "Unable to save product.");
              }
            }}
          >
            <Field label="Product Name">
              <input
                value={form.name}
                onChange={(event) => setForm({ ...form, name: event.target.value })}
                placeholder="DualSense Controller"
                required
              />
            </Field>
            <Field label="Category">
              <select
                value={form.category}
                onChange={(event) =>
                  setForm({ ...form, category: event.target.value })
                }
              >
                <option>Controllers</option>
                <option>Headsets</option>
                <option>Accessories</option>
                <option>Keyboards</option>
                <option>PS5</option>
              </select>
            </Field>
            <div className="form-split">
              <Field label="Price">
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={form.price}
                  onChange={(event) => setForm({ ...form, price: event.target.value })}
                  placeholder="69.99"
                  required
                />
              </Field>
              <Field label="Inventory">
                <input
                  type="number"
                  min="0"
                  value={form.inventory}
                  onChange={(event) =>
                    setForm({ ...form, inventory: event.target.value })
                  }
                  placeholder="18"
                  required
                />
              </Field>
            </div>
            <Field label="Image URL / Upload">
              <input
                value={form.imageUrl}
                onChange={(event) =>
                  setForm({ ...form, imageUrl: event.target.value })
                }
                placeholder="https://... or use file upload"
              />
              <input
                type="file"
                accept="image/png,image/jpeg,image/webp"
                onChange={handleFileChange}
              />
            </Field>
            <label className="checkbox-row">
              <input
                type="checkbox"
                checked={form.featured}
                onChange={(event) =>
                  setForm({ ...form, featured: event.target.checked })
                }
              />
              <span>Feature this product on the storefront</span>
            </label>
            <div className="form-actions">
              <button className="primary-button" type="submit">
                {isEditing ? "Save Changes" : "Add Product"}
              </button>
              {isEditing ? (
                <button
                  className="secondary-button"
                  type="button"
                  onClick={resetForm}
                >
                  Cancel Edit
                </button>
              ) : null}
            </div>
            {errorMessage ? <p className="form-error">{errorMessage}</p> : null}
          </form>
        </Panel>
        <Panel title="Catalog" subtitle="Toggle featured state directly from the list">
          <div className="product-grid">
            {filteredProducts.map((product) => (
              <div className="product-card" key={product.id}>
                <img src={product.imageUrl} alt={product.name} />
                <div className="product-card__body">
                  <strong>{product.name}</strong>
                  <p>
                    {product.category} • ${product.price.toFixed(2)}
                  </p>
                  <span>{product.inventory} in stock</span>
                  <div className="product-card__actions">
                    <button
                      className="secondary-button"
                      onClick={() => {
                        setEditingId(product.id);
                        setForm({
                          name: product.name,
                          category: product.category,
                          price: String(product.price),
                          inventory: String(product.inventory),
                          imageUrl: product.imageUrl,
                          imageData: "",
                          imageType: "",
                          featured: !!product.featured,
                        });
                      }}
                    >
                      Edit
                    </button>
                    <button
                      className="secondary-button"
                      onClick={async () => {
                        try {
                          await toggleFeatureProduct(product.id);
                        } catch (error) {
                          setErrorMessage(error.message || "Unable to update product feature.");
                        }
                      }}
                    >
                      {product.featured ? "Remove Feature" : "Mark Featured"}
                    </button>
                    <button
                      className="secondary-button"
                      onClick={async () => {
                        try {
                          await deleteProduct(product.id);
                          if (editingId === product.id) {
                            resetForm();
                          }
                        } catch (error) {
                          setErrorMessage(error.message || "Unable to delete product.");
                        }
                      }}
                    >
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Panel>
      </div>
    </div>
  );
}




