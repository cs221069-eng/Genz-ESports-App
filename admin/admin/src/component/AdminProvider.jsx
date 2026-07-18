/* eslint-disable react-refresh/only-export-components */
import { createContext, useContext, useEffect, useMemo, useState, useCallback } from "react";

const STORAGE_KEY = "genz-admin-state";

const API_BASE = import.meta.env.VITE_API_BASE || 'http://localhost:3000';

const defaultState = {
  admin: {
    email: "admin@genzesports.com",
    password: "Champion25",
    name: "Moiz Siddiqui",
    role: "Operations Admin",
  },
  authToken: "",
  isAuthenticated: false,
  settings: {
    brandName: "GenZ eSports Admin",
    supportEmail: "support@genzesports.com",
    loginHeadline: "Control every tournament, stream, order, and champion story.",
    dashboardHeadline: "Pakistan's competitive gaming stack in one control room.",
    primaryColor: "#17b7ff",
    secondaryColor: "#ffffff",
  },
  tournaments: [
    {
      id: "T-1001",
      title: "Karachi Open Qualifier",
      game: "FC 25",
      status: "Live",
      schedule: "2026-05-25 18:00",
      prize: "$2,500",
      attendance: "48 / 64 Players",
      streamUrl: "https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13",
      actionText: "Join Now",
    },
    {
      id: "T-1002",
      title: "Tekken Fight Night",
      game: "Tekken 8",
      status: "Upcoming",
      schedule: "2026-05-29 20:30",
      prize: "$1,200",
      attendance: "22 / 32 Players",
      streamUrl: "https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13",
      actionText: "Register",
    },
  ],
  liveVideos: [
    {
      id: "L-2001",
      title: "GenZ Arena Main Stream",
      streamer: "Arena Desk",
      viewers: "6.8K",
      status: "Live",
      embedUrl: "https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13",
      thumbnail:
        "https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg",
    },
    {
      id: "L-2002",
      title: "FC 25 Matchday Stream",
      streamer: "Commentary Booth",
      viewers: "4.1K",
      status: "Scheduled",
      embedUrl: "https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13",
      thumbnail:
        "https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg",
    },
  ],
  highlights: [
    {
      id: "H-3001",
      title: "Areeb Rehman Championship Run",
      category: "Player Story",
      duration: "03:42",
      published: "2026-05-20",
      thumbnail:
        "https://img.youtube.com/vi/-Ot2QrjWCzg/maxresdefault.jpg",
      videoUrl: "https://www.youtube.com/watch?v=-Ot2QrjWCzg",
    },
    {
      id: "H-3002",
      title: "Top 10 Weekend Goals",
      category: "FC 25",
      duration: "08:14",
      published: "2026-05-21",
      thumbnail:
        "https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg",
      videoUrl: "https://www.youtube.com/watch?v=-Ot2QrjWCzg",
    },
  ],
  products: [
    {
      id: "P-4001",
      name: "DualSense Controller",
      category: "Controllers",
      price: 69.99,
      inventory: 18,
      featured: true,
      imageUrl:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuCf6RrDtDKUCu0-dDuBQrcb6lgqOWahsHQjGwL0iHTopSZrzUaUt21hcbszCUDSIV5hW3DeBj6ikk3XVWjTk75T6u0iz8WgcZ4ozYayYj-Y8X0WZZr9CCaBSKdYBRNKUq5s-YmTs1rwSpgDUbCvQPBz9pTWq0d__RIF1deUmpx0a-1tB99EWkBgDB1oM4_hyW-lMGMohFYT5GmS-tJ0Kx70FkSBwPRJQ6ERrLsowOCbZOj6LccaHS89-hmQMcC-hO0toU1adDFN18BM",
    },
    {
      id: "P-4002",
      name: "Pro Gaming Headset",
      category: "Headsets",
      price: 129,
      inventory: 9,
      featured: false,
      imageUrl:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuCfu2t6GbWKB8rZ3VvAm5eZMxpxkesKSDF5JCCJeyktAiSdrCiCAsdcAi3MBT_Xy_PswmiQmt8hdsRq9D5KYtrFuHpyrxr-5xgfLqmamITTZoNQwoKEFfrYr0q0PCNOjU88YDs7GmrbzmvOM3ezv7HuOn1EhIwoCsb14U1W5PPBXj2wgkTASCga8RCbC3q8SV9XyXuunXTmf6GhcD4VFIMZRfpWLRhzRCo9ZtbPPWk5VLG3088PYIVE03Liw6AC2o-0pT_S6mG0RIVg",
    },
  ],
  brackets: [],
};

const AdminContext = createContext(null);

// Restores the saved admin state from local storage when the app reloads.
function readInitialState() {
  const saved = window.localStorage.getItem(STORAGE_KEY);
  if (!saved) {
    return defaultState;
  }

  try {
    const restored = JSON.parse(saved);
    return {
      ...defaultState,
      ...restored,
      isAuthenticated: Boolean(restored.authToken),
      authToken: restored.authToken ?? '',
    };
  } catch {
    return defaultState;
  }
}

// Provides the admin data, auth actions, and API helpers to the whole admin UI.
export function AdminProvider({ children }) {
  const [state, setState] = useState(readInitialState);

  // Loads tournament data from the backend for the dashboard and management screens.
  const loadTournaments = useCallback(async (token) => {
    if (!token) {
      return;
    }

    try {
      const response = await fetch(`${API_BASE}/api/tournaments`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (!response.ok) {
        return;
      }

      const tournaments = await response.json();
      const normalized = (tournaments || []).map((t) => ({ ...t, id: t.id ?? t._id }));
      setState((current) => ({ ...current, tournaments: normalized }));
    } catch (error) {
      console.error('Unable to load tournaments', error);
    }
  }, [state.authToken]);

  // Loads live streams and highlights from the media API.
  const loadMedia = useCallback(async () => {
    try {
      const response = await fetch(`${API_BASE}/api/media`);

      if (!response.ok) {
        return;
      }

      const mediaItems = await response.json();
      const liveVideos = (mediaItems || [])
        .filter((item) => item.type === 'live')
        .map((item) => ({ ...item, id: item.id ?? item._id }));
      const highlights = (mediaItems || [])
        .filter((item) => item.type === 'highlight')
        .map((item) => ({
          ...item,
          id: item.id ?? item._id,
          videoUrl: item.embedUrl ?? item.videoUrl,
        }));

      setState((current) => ({ ...current, liveVideos, highlights }));
    } catch (error) {
      console.error('Unable to load media', error);
    }
  }, []);

  // Loads shop products for the product catalog view.
  const loadProducts = useCallback(async () => {
    try {
      const response = await fetch(`${API_BASE}/api/products`);
      if (!response.ok) {
        return;
      }

      const products = await response.json();
      const normalized = (products || []).map((item) => ({
        ...item,
        id: item.id ?? item._id,
      }));

      setState((current) => ({ ...current, products: normalized }));
    } catch (error) {
      console.error('Unable to load products', error);
    }
  }, []);
  // Loads bracket configurations so bracket pages can be edited and previewed.
  const loadBrackets = useCallback(async (token) => {
    const activeToken = token || state.authToken;
    if (!activeToken) return;
    try {
      const response = await fetch(`${API_BASE}/api/brackets`, {
        headers: {
          Authorization: `Bearer ${activeToken}`
        }
      });
      if (!response.ok) {
        return;
      }

      const brackets = await response.json();
      const normalized = (brackets || []).map((item) => ({
        ...item,
        id: item.id ?? item._id,
      }));

      setState((current) => ({ ...current, brackets: normalized }));
    } catch (error) {
      console.error('Unable to load brackets', error);
    }
  }, [state.authToken]);

  useEffect(() => {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  }, [state]);

  useEffect(() => {
    if (!state.isAuthenticated || !state.authToken) {
      return;
    }

    const syncAdminData = async () => {
      await loadTournaments(state.authToken);
      await loadMedia();
      await loadProducts();
      await loadBrackets(state.authToken);
    };

    void syncAdminData();
  }, [state.isAuthenticated, state.authToken, loadBrackets, loadMedia, loadProducts, loadTournaments]);

  const value = useMemo(() => {

    // Authenticates the admin and stores the returned token in state.
    const login = async ({ email, password }) => {
      try {
        const response = await fetch(`${API_BASE}/api/admin/login`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ email, password }),
        });

        if (!response.ok) {
          return false;
        }

        const body = await response.json();
        const token = body.token;

        setState((current) => ({
          ...current,
          isAuthenticated: true,
          authToken: token,
          admin: {
            ...current.admin,
            email: body.user?.email || current.admin.email,
            name: body.user?.fullname || current.admin.name,
            role: body.user?.role || current.admin.role,
          },
        }));

        await loadTournaments(token);
        await loadMedia();
        return true;
      } catch (error) {
        console.error('Admin login failed', error);
        return false;
      }
    };

    // Clears auth state and removes the saved admin session data.
    const logout = () => {
      window.localStorage.removeItem(STORAGE_KEY);
      setState({
        ...defaultState,
        isAuthenticated: false,
        authToken: '',
      });
    };

    // Creates a new tournament entry and immediately updates local state.
    const addTournament = async (payload, imageFile) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const formData = new FormData();
      Object.entries(payload).forEach(([key, value]) => {
        if (value != null) {
          formData.append(key, value);
        }
      });

      if (imageFile) {
        formData.append('image', imageFile);
      }

      const response = await fetch(`${API_BASE}/api/tournaments`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
        },
        body: formData,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to save tournament');
      }

      const tournament = await response.json();
      const normalized = { ...tournament, id: tournament.id ?? tournament._id };
      setState((current) => ({
        ...current,
        tournaments: [normalized, ...current.tournaments],
      }));
      return normalized;
    };

    // Updates an existing tournament entry and refreshes the local list.
    const updateTournament = async (id, payload, imageFile) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const formData = new FormData();
      Object.entries(payload).forEach(([key, value]) => {
        if (value != null) {
          formData.append(key, value);
        }
      });

      if (imageFile) {
        formData.append('image', imageFile);
      }

      const response = await fetch(`${API_BASE}/api/tournaments/${id}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
        },
        body: formData,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to update tournament');
      }

      const tournament = await response.json();
      const normalized = { ...tournament, id: tournament.id ?? tournament._id };
      setState((current) => ({
        ...current,
        tournaments: current.tournaments.map((t) => (t.id === normalized.id ? normalized : t)),
      }));

      return normalized;
    };

    // Removes a tournament from the backend and the current state.
    const deleteTournament = async (id) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/tournaments/${id}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
        },
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to delete tournament');
      }

      setState((current) => ({
        ...current,
        tournaments: current.tournaments.filter((t) => t.id !== id),
      }));

      return true;
    };

    // Creates a new live stream entry for the media section.
    const addLiveVideo = async (payload) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/media/live`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to save live video');
      }

      const liveVideo = await response.json();
      const normalized = { ...liveVideo, id: liveVideo.id ?? liveVideo._id };
      setState((current) => ({
        ...current,
        liveVideos: [normalized, ...current.liveVideos],
      }));
      return normalized;
    };

    // Creates a highlight reel entry and stores it in the highlight list.
    const addHighlight = async (payload) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/media/highlights`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...payload,
          embedUrl: payload.embedUrl ?? payload.videoUrl,
        }),
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to save highlight');
      }

      const highlight = await response.json();
      const normalized = {
        ...highlight,
        id: highlight.id ?? highlight._id,
        videoUrl: highlight.embedUrl ?? highlight.videoUrl,
      };
      setState((current) => ({
        ...current,
        highlights: [normalized, ...current.highlights],
      }));
      return normalized;
    };

    // Updates an existing live video entry in state after the API responds.
    const updateLiveVideo = async (id, payload) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/media/${id}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to update live video');
      }

      const liveVideo = await response.json();
      const normalized = { ...liveVideo, id: liveVideo.id ?? liveVideo._id };
      setState((current) => ({
        ...current,
        liveVideos: current.liveVideos.map((item) =>
          item.id === normalized.id ? normalized : item,
        ),
      }));
      return normalized;
    };

    // Updates an existing highlight entry and keeps the UI in sync.
    const updateHighlight = async (id, payload) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/media/${id}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...payload,
          embedUrl: payload.embedUrl ?? payload.videoUrl,
        }),
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to update highlight');
      }

      const highlight = await response.json();
      const normalized = {
        ...highlight,
        id: highlight.id ?? highlight._id,
        videoUrl: highlight.embedUrl ?? highlight.videoUrl,
      };
      setState((current) => ({
        ...current,
        highlights: current.highlights.map((item) =>
          item.id === normalized.id ? normalized : item,
        ),
      }));
      return normalized;
    };

    // Deletes a media item from both the backend and the local state.
    const deleteMediaItem = async (id) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/media/${id}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
        },
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to delete media item');
      }

      setState((current) => ({
        ...current,
        liveVideos: current.liveVideos.filter((item) => item.id !== id),
        highlights: current.highlights.filter((item) => item.id !== id),
      }));
      return true;
    };

    // Adds a new shop product and updates the product catalog immediately.
    const addProduct = async (payload) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const headers = { Authorization: `Bearer ${state.authToken}` };
      let body;

      if (payload.imageData && payload.imageType) {
        body = JSON.stringify(payload);
        headers['Content-Type'] = 'application/json';
      } else {
        const formData = new FormData();
        Object.entries(payload).forEach(([key, value]) => {
          if (value != null) {
            formData.append(key, value);
          }
        });
        if (payload.imageFile) {
          formData.append('image', payload.imageFile);
        }
        body = formData;
      }

      const response = await fetch(`${API_BASE}/api/products`, {
        method: 'POST',
        headers,
        body,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to save product');
      }

      const product = await response.json();
      const normalized = { ...product, id: product.id ?? product._id };
      setState((current) => ({
        ...current,
        products: [normalized, ...current.products],
      }));
      return normalized;
    };

    // Updates an existing product and refreshes the local catalog list.
    const updateProduct = async (id, payload) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const headers = { Authorization: `Bearer ${state.authToken}` };
      let body;

      if (payload.imageData && payload.imageType) {
        body = JSON.stringify(payload);
        headers['Content-Type'] = 'application/json';
      } else {
        const formData = new FormData();
        Object.entries(payload).forEach(([key, value]) => {
          if (value != null) {
            formData.append(key, value);
          }
        });
        if (payload.imageFile) {
          formData.append('image', payload.imageFile);
        }
        body = formData;
      }

      const response = await fetch(`${API_BASE}/api/products/${id}`, {
        method: 'PUT',
        headers,
        body,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to update product');
      }

      const product = await response.json();
      const normalized = { ...product, id: product.id ?? product._id };
      setState((current) => ({
        ...current,
        products: current.products.map((item) =>
          item.id === normalized.id ? normalized : item,
        ),
      }));
      return normalized;
    };

    // Deletes a product from the storefront catalog.
    const deleteProduct = async (id) => {
      if (!state.authToken) {
        throw new Error('Admin authentication is required');
      }

      const response = await fetch(`${API_BASE}/api/products/${id}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${state.authToken}`,
        },
      });

      if (!response.ok) {
        const body = await response.json().catch(() => null);
        throw new Error(body?.message ?? 'Unable to delete product');
      }

      setState((current) => ({
        ...current,
        products: current.products.filter((item) => item.id !== id),
      }));
      return true;
    };

    return {
      ...state,
      login,
      logout,
      addTournament,
      updateTournament,
      deleteTournament,
      addLiveVideo,
      updateLiveVideo,
      addHighlight,
      updateHighlight,
      deleteMediaItem,
      addProduct,
      updateProduct,
      deleteProduct,
      updateSettings: (payload) => {
        setState((current) => ({
          ...current,
          settings: { ...current.settings, ...payload },
        }));
      },
      // Toggles the featured state of a product in the shop catalog.
      toggleFeatureProduct: async (id) => {
        if (!state.authToken) {
          throw new Error('Admin authentication is required');
        }

        const product = state.products.find((item) => item.id === id);
        if (!product) {
          return;
        }

        const response = await fetch(`${API_BASE}/api/products/${id}`, {
          method: 'PUT',
          headers: {
            Authorization: `Bearer ${state.authToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ featured: !product.featured }),
        });

        if (!response.ok) {
          const body = await response.json().catch(() => null);
          throw new Error(body?.message ?? 'Unable to update product feature state');
        }

        const updated = await response.json();
        const normalized = { ...updated, id: updated.id ?? updated._id };
        setState((current) => ({
          ...current,
          products: current.products.map((item) =>
            item.id === normalized.id ? normalized : item,
          ),
        }));
      },
      // Rotates a tournament through the available status values.
      cycleTournamentStatus: (id) => {
        const statuses = ['Upcoming', 'Live', 'Completed'];
        setState((current) => ({
          ...current,
          tournaments: current.tournaments.map((item) => {
            if (item.id !== id) {
              return item;
            }

            const nextIndex =
              (statuses.indexOf(item.status) + 1) % statuses.length;
            return { ...item, status: statuses[nextIndex] };
          }),
        }));
      },
      // Fetches tournament registrations for a specific game, if provided.
      fetchRegistrations: async (game, token) => {
        const activeToken = token || state.authToken;
        if (!activeToken) return [];
        try {
          const query = game ? `?game=${encodeURIComponent(game)}` : '';
          const response = await fetch(`${API_BASE}/api/tournamentsForm/registrations${query}`, {
            headers: {
              Authorization: `Bearer ${activeToken}`
            }
          });
          if (!response.ok) return [];
          return await response.json();
        } catch (error) {
          console.error('Unable to fetch registrations', error);
          return [];
        }
      },
      // Fetches bracket data from the backend with auth protection.
      fetchBrackets: async (token) => {
        const activeToken = token || state.authToken;
        if (!activeToken) throw new Error('No authorization token provided.');
        try {
          const response = await fetch(`${API_BASE}/api/brackets`, {
            headers: {
              Authorization: `Bearer ${activeToken}`
            }
          });
          if (!response.ok) {
            const errBody = await response.json().catch(() => null);
            throw new Error(errBody?.message || `Access Denied (Status: ${response.status})`);
          }
          const list = await response.json();
          return (list || []).map((item) => ({ ...item, id: item.id ?? item._id }));
        } catch (error) {
          console.error('Unable to fetch brackets', error);
          throw error;
        }
      },
      // Saves a new bracket definition and adds it to local state.
      saveBracket: async (bracketData) => {
        if (!state.authToken) {
          throw new Error('Admin authentication is required');
        }
        const response = await fetch(`${API_BASE}/api/brackets`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${state.authToken}`,
          },
          body: JSON.stringify(bracketData),
        });
        if (!response.ok) {
          const body = await response.json().catch(() => null);
          throw new Error(body?.message ?? 'Unable to save bracket');
        }
        const saved = await response.json();
        const normalized = { ...saved, id: saved.id ?? saved._id };
        setState((current) => ({
          ...current,
          brackets: [normalized, ...current.brackets],
        }));
        return normalized;
      },
      // Updates an existing bracket config and refreshes the list.
      updateBracket: async (id, updateData) => {
        if (!state.authToken) {
          throw new Error('Admin authentication is required');
        }
        const response = await fetch(`${API_BASE}/api/brackets/${id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${state.authToken}`,
          },
          body: JSON.stringify(updateData),
        });
        if (!response.ok) {
          const body = await response.json().catch(() => null);
          throw new Error(body?.message ?? 'Unable to update bracket');
        }
        const updated = await response.json();
        const normalized = { ...updated, id: updated.id ?? updated._id };
        setState((current) => ({
          ...current,
          brackets: current.brackets.map((item) =>
            item.id === normalized.id ? normalized : item
          ),
        }));
        return normalized;
      },
      // Deletes a bracket entry from the backend and current state.
      deleteBracket: async (id) => {
        if (!state.authToken) {
          throw new Error('Admin authentication is required');
        }
        const response = await fetch(`${API_BASE}/api/brackets/${id}`, {
          method: 'DELETE',
          headers: {
            Authorization: `Bearer ${state.authToken}`,
          },
        });
        if (!response.ok) {
          const body = await response.json().catch(() => null);
          throw new Error(body?.message ?? 'Unable to delete bracket');
        }
        setState((current) => ({
          ...current,
          brackets: current.brackets.filter((item) => item.id !== id),
        }));
        return true;
      },
    };
  }, [state]);

  return (
    <AdminContext.Provider value={value}>{children}</AdminContext.Provider>
  );
}

export function useAdmin() {
  const context = useContext(AdminContext);

  if (!context) {
    throw new Error("useAdmin must be used inside AdminProvider");
  }

  return context;
}
