// Shared admin UI primitives used across the dashboard and bracket tools.
// Keeping these in one place removes duplication and makes future styling changes simpler.

export function PageIntro({ title, description, action }) {
  return (
    <div className="page-intro">
      <div>
        <p className="eyebrow">genz esports operations</p>
        <h1>{title}</h1>
        <p className="page-intro__copy">{description}</p>
      </div>
      {action}
    </div>
  );
}

export function Panel({ title, subtitle, children, aside }) {
  return (
    <article className="panel">
      <div className="panel__header">
        <div>
          <h3>{title}</h3>
          {subtitle ? <p>{subtitle}</p> : null}
        </div>
        {aside}
      </div>
      {children}
    </article>
  );
}

export function MetricCard({ label, value, note }) {
  return (
    <div className="metric-card">
      <p>{label}</p>
      <strong>{value}</strong>
      <span>{note}</span>
    </div>
  );
}

export function DataTable({ columns, rows, renderRow }) {
  return (
    <div className="table-shell">
      <div className="table-shell__head">
        {columns.map((column) => (
          <span key={column}>{column}</span>
        ))}
      </div>
      <div className="table-shell__body">
        {Array.isArray(rows) ? rows.map(renderRow) : null}
      </div>
    </div>
  );
}

export function Field({ label, children }) {
  return (
    <label className="field">
      <span>{label}</span>
      {children}
    </label>
  );
}

export function StatusBadge({ value }) {
  const normalized = String(value ?? "")
    .trim()
    .toLowerCase()
    .replaceAll(" ", "-");

  return <span className={`status-badge status-badge--${normalized}`}>{value}</span>;
}

export function BracketRoundColumn({ title, matchCount, tone, compact }) {
  return (
    <div className={`bracket-round bracket-round--${tone}`}>
      <div className="bracket-round__header">
        <strong>{title}</strong>
        <span>{matchCount} matches</span>
      </div>

      <div className={`bracket-round__matches${compact ? " bracket-round__matches--compact" : ""}`}>
        {Array.from({ length: matchCount }, (_, index) => (
          <article className="match-card" key={`${title}-${index}`}>
            <div className="match-card__seed">
              <span>{tone === "winner" ? "W" : "L"}{index + 1}</span>
              <small>BO3</small>
            </div>
            <div className="match-card__players">
              <div className="match-card__player">
                <span>Player {index * 2 + 1}</span>
                <b>0</b>
              </div>
              <div className="match-card__player match-card__player--muted">
                <span>Player {index * 2 + 2}</span>
                <b>0</b>
              </div>
            </div>
          </article>
        ))}
      </div>
    </div>
  );
}

export function BracketBoard({ title, eyebrow, rounds, tone, compact = false }) {
  return (
    <section className={`bracket-board bracket-board--${tone}`}>
      <div className="bracket-board__intro">
        <p className="eyebrow">{eyebrow}</p>
        <h3>{title}</h3>
      </div>

      <div className="bracket-board__rail">
        {rounds.map((round) => (
          <BracketRoundColumn
            key={round.id}
            title={round.title}
            matchCount={round.matchCount}
            tone={tone}
            compact={compact}
          />
        ))}
      </div>
    </section>
  );
}
