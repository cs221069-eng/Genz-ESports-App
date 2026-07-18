import { useMemo, useState, useEffect } from "react";
import { useAdmin } from "./AdminProvider";
import { Field, PageIntro, Panel, StatusBadge, BracketBoard } from "./ui";

const BRACKET_OPTIONS = [
  { value: 64, label: "64 Players", entryLabel: "Top 64" },
  { value: 128, label: "128 Players", entryLabel: "Top 128" },
];

function buildRoundTitle(index, total, prefix) {
  if (index === total - 1) {
    return `${prefix} Final`;
  }

  if (index === total - 2) {
    return `${prefix} Semi Final`;
  }

  if (index === total - 3) {
    return `${prefix} Quarter Final`;
  }

  return `${prefix} Round ${index + 1}`;
}

function buildWinnerRounds(playerCount, playerNames) {
  const totalRounds = Math.log2(playerCount);
  const winnerRounds = [];
  let matchNumber = 1;

  for (let roundIndex = 0; roundIndex < totalRounds; roundIndex += 1) {
    const matchCount = playerCount / 2 ** (roundIndex + 1);
    const priorRound = winnerRounds[roundIndex - 1];

    const matches = Array.from({ length: matchCount }, (_, matchIndex) => {
      const id = `M${matchNumber}`;
      matchNumber += 1;

      if (roundIndex === 0) {
        return {
          id,
          slots: [
            { label: playerNames[matchIndex * 2] ?? `Player ${matchIndex * 2 + 1}` },
            { label: playerNames[matchIndex * 2 + 1] ?? `Player ${matchIndex * 2 + 2}` },
          ],
        };
      }

      return {
        id,
        slots: [
          { from: priorRound.matches[matchIndex * 2].id, type: "winner" },
          { from: priorRound.matches[matchIndex * 2 + 1].id, type: "winner" },
        ],
      };
    });

    winnerRounds.push({
      id: `winner-${roundIndex + 1}`,
      title: buildRoundTitle(roundIndex, totalRounds, "Winners"),
      matchCount,
      matches,
    });
  }

  return winnerRounds;
}

function buildLoserRounds(playerCount, winnerRounds) {
  const totalWinnerRounds = winnerRounds.length;
  const loserRoundsCount = totalWinnerRounds * 2 - 2;
  const loserRounds = [];
  let matchNumber = winnerRounds.flatMap((round) => round.matches).length + 1;

  for (let roundIndex = 0; roundIndex < loserRoundsCount; roundIndex += 1) {
    const matchCount = Math.max(1, Math.ceil(playerCount / 2 ** (Math.floor(roundIndex / 2) + 2)));
    const priorLoserRound = loserRounds[roundIndex - 1];
    const sourceWinnerRound = winnerRounds[Math.floor(roundIndex / 2) + (roundIndex % 2 === 0 ? 0 : 1)];

    const matches = Array.from({ length: matchCount }, (_, matchIndex) => {
      const id = `M${matchNumber}`;
      matchNumber += 1;

      if (roundIndex === 0) {
        return {
          id,
          slots: [
            { from: sourceWinnerRound.matches[matchIndex * 2].id, type: "loser" },
            { from: sourceWinnerRound.matches[matchIndex * 2 + 1].id, type: "loser" },
          ],
        };
      }

      if (roundIndex % 2 === 0) {
        return {
          id,
          slots: [
            { from: priorLoserRound.matches[matchIndex * 2].id, type: "winner" },
            { from: priorLoserRound.matches[matchIndex * 2 + 1].id, type: "winner" },
          ],
        };
      }

      return {
        id,
        slots: [
          { from: priorLoserRound.matches[matchIndex].id, type: "winner" },
          { from: sourceWinnerRound.matches[matchIndex].id, type: "loser" },
        ],
      };
    });

    loserRounds.push({
      id: `loser-${roundIndex + 1}`,
      title: roundIndex === loserRoundsCount - 1 ? "Losers Final" : `Losers Round ${roundIndex + 1}`,
      matchCount,
      matches,
    });
  }

  return loserRounds;
}

function buildSingleEliminationRounds(playerCount, playerNames) {
  const totalRounds = Math.log2(playerCount);
  const rounds = [];
  let matchNumber = 1;

  for (let roundIndex = 0; roundIndex < totalRounds; roundIndex += 1) {
    const matchCount = playerCount / 2 ** (roundIndex + 1);

    const matches = Array.from({ length: matchCount }, (_, matchIndex) => {
      const id = `M${matchNumber}`;
      matchNumber += 1;

      if (roundIndex === 0) {
        return {
          id,
          slots: [
            { label: playerNames[matchIndex * 2] ?? `Player ${matchIndex * 2 + 1}` },
            { label: playerNames[matchIndex * 2 + 1] ?? `Player ${matchIndex * 2 + 2}` },
          ],
        };
      }

      const previous = rounds[roundIndex - 1];
      return {
        id,
        slots: [
          { from: previous.matches[matchIndex * 2].id, type: "winner" },
          { from: previous.matches[matchIndex * 2 + 1].id, type: "winner" },
        ],
      };
    });

    rounds.push({
      id: `se-${roundIndex + 1}`,
      title: buildRoundTitle(roundIndex, totalRounds, ""),
      matchCount,
      matches,
    });
  }

  return rounds;
}


function SingleEliminationBracket({ rounds, playerNames, matchResults, onSelectMatchWinner, isAdmin }) {
  return (
    <div className="single-elimination-container">
      <div className="se-players-column">
        <div className="se-players-header">Players</div>
        {playerNames.map((playerName, i) => (
          <div className="se-player" key={`player-${i}`}>
            <span className="se-player__number">{i + 1}</span>
            <span className="se-player__name">{playerName}</span>
          </div>
        ))}
      </div>

      <div className="se-rounds">
        {rounds.map((round) => (
          <div className="se-round" key={round.id}>
            <div className="se-round__header">{round.title}</div>
            <div className="se-matches">
              {round.matches.map((match) => {
              const slotA = match.slots[0];
              const slotB = match.slots[1];
              const labelA = getSlotLabel(slotA, matchResults);
              const labelB = getSlotLabel(slotB, matchResults);
              const result = matchResults[match.id];

              return (
                <div className="se-match" key={match.id}>
                  <div className="se-match__meta">
                    <span>{match.id}</span>
                    <small>BO3</small>
                  </div>
                  <div className="se-match__player">
                    <span>{labelA}</span>
                    <span className="se-score">{result?.winnerIndex === 0 ? 'WIN' : '0–0'}</span>
                  </div>
                  {isAdmin ? (
                    <button
                      className="se-match__button"
                      type="button"
                      onClick={() => onSelectMatchWinner(match.id, 0, labelA, labelB)}
                    >
                      Win
                    </button>
                  ) : (
                    <button
                      className="se-match__button"
                      type="button"
                      disabled
                      style={{ opacity: 0.5, cursor: 'not-allowed' }}
                    >
                      Win
                    </button>
                  )}
                  <div className="se-match__divider" />
                  <div className="se-match__player">
                    <span>{labelB}</span>
                    <span className="se-score">{result?.winnerIndex === 1 ? 'WIN' : '0–0'}</span>
                  </div>
                  {isAdmin ? (
                    <button
                      className="se-match__button"
                      type="button"
                      onClick={() => onSelectMatchWinner(match.id, 1, labelB, labelA)}
                    >
                      Win
                    </button>
                  ) : (
                    <button
                      className="se-match__button"
                      type="button"
                      disabled
                      style={{ opacity: 0.5, cursor: 'not-allowed' }}
                    >
                      Win
                    </button>
                  )}
                </div>
              );
            })}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function DoubleEliminationBracket({ winnerRounds, loserRounds, playerNames, grandFinal, resetFinal, matchResults, onSelectMatchWinner, isAdmin }) {
  return (
    <div className="double-elimination-wrapper">
      <div className="de-section">
        <div className="de-section__title">Winner Bracket</div>
        <div className="double-elimination-container">
          <div className="de-players-column">
            <div className="de-players-header">Players</div>
            {playerNames.map((playerName, i) => (
              <div className="de-player" key={`winner-player-${i}`}>
                <span className="de-player__number">{i + 1}</span>
                <span className="de-player__name">{playerName}</span>
              </div>
            ))}
          </div>

          <div className="de-rounds">
            {winnerRounds.map((round) => (
              <div className="de-round" key={round.id}>
                <div className="de-round__header de-round__header--winner">{round.title}</div>
                <div className="de-matches">
                  {round.matches.map((match) => {
                    const labelA = getSlotLabel(match.slots[0], matchResults);
                    const labelB = getSlotLabel(match.slots[1], matchResults);
                    const result = matchResults[match.id];

                    return (
                      <div className="de-match de-match--winner" key={match.id}>
                        <div className="de-match__meta">
                          <span>{match.id}</span>
                          <small>BO3</small>
                        </div>
                        <div className="de-match__player">
                          <span>{labelA}</span>
                          <span className="de-score">{result?.winnerIndex === 0 ? 'WIN' : '0–0'}</span>
                        </div>
                        {isAdmin ? (
                          <button
                            className="de-match__button"
                            type="button"
                            onClick={() => onSelectMatchWinner(match.id, 0, labelA, labelB)}
                          >
                            Win
                          </button>
                        ) : (
                          <button
                            className="de-match__button"
                            type="button"
                            disabled
                            style={{ opacity: 0.5, cursor: 'not-allowed' }}
                          >
                            Win
                          </button>
                        )}
                        <div className="de-match__player">
                          <span>{labelB}</span>
                          <span className="de-score">{result?.winnerIndex === 1 ? 'WIN' : '0–0'}</span>
                        </div>
                        {isAdmin ? (
                          <button
                            className="de-match__button"
                            type="button"
                            onClick={() => onSelectMatchWinner(match.id, 1, labelB, labelA)}
                          >
                            Win
                          </button>
                        ) : (
                          <button
                            className="de-match__button"
                            type="button"
                            disabled
                            style={{ opacity: 0.5, cursor: 'not-allowed' }}
                          >
                            Win
                          </button>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="de-section">
        <div className="de-section__title">Loser Bracket</div>
        <div className="double-elimination-container">
          <div className="de-players-column de-players-column--loser">
            <div className="de-players-header de-players-header--loser">Losers</div>
            <div className="de-placeholder-losers">Dropped players pool</div>
          </div>

          <div className="de-rounds">
            {loserRounds.map((round) => (
              <div className="de-round" key={round.id}>
                <div className="de-round__header de-round__header--loser">{round.title}</div>
                <div className="de-matches">
                  {round.matches.map((match) => {
                    const labelA = getSlotLabel(match.slots[0], matchResults);
                    const labelB = getSlotLabel(match.slots[1], matchResults);
                    const result = matchResults[match.id];

                    return (
                      <div className="de-match de-match--loser" key={match.id}>
                        <div className="de-match__meta">
                          <span>{match.id}</span>
                          <small>BO3</small>
                        </div>
                        <div className="de-match__player">
                          <span>{labelA}</span>
                          <span className="de-score">{result?.winnerIndex === 0 ? 'WIN' : '0–0'}</span>
                        </div>
                        {isAdmin ? (
                          <button
                            className="de-match__button"
                            type="button"
                            onClick={() => onSelectMatchWinner(match.id, 0, labelA, labelB)}
                          >
                            Win
                          </button>
                        ) : (
                          <button
                            className="de-match__button"
                            type="button"
                            disabled
                            style={{ opacity: 0.5, cursor: 'not-allowed' }}
                          >
                            Win
                          </button>
                        )}
                        <div className="de-match__player">
                          <span>{labelB}</span>
                          <span className="de-score">{result?.winnerIndex === 1 ? 'WIN' : '0–0'}</span>
                        </div>
                        {isAdmin ? (
                          <button
                            className="de-match__button"
                            type="button"
                            onClick={() => onSelectMatchWinner(match.id, 1, labelB, labelA)}
                          >
                            Win
                          </button>
                        ) : (
                          <button
                            className="de-match__button"
                            type="button"
                            disabled
                            style={{ opacity: 0.5, cursor: 'not-allowed' }}
                          >
                            Win
                          </button>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="de-finals">
        <div className="de-final-card">
          <h4>Grand Final</h4>
          <div className="de-match de-match--grand">
            <div className="de-match__meta">
              <span>{grandFinal.id}</span>
              <small>BO5</small>
            </div>
            <div className="de-match__player">
              <span>{getSlotLabel(grandFinal.slots[0], matchResults)}</span>
              <span className="de-score">0–0</span>
            </div>
            {isAdmin ? (
              <button
                className="de-match__button"
                type="button"
                onClick={() => onSelectMatchWinner(grandFinal.id, 0, getSlotLabel(grandFinal.slots[0], matchResults), getSlotLabel(grandFinal.slots[1], matchResults))}
              >
                Win
              </button>
            ) : (
              <button
                className="de-match__button"
                type="button"
                disabled
                style={{ opacity: 0.5, cursor: 'not-allowed' }}
              >
                Win
              </button>
            )}
            <div className="de-match__player">
              <span>{getSlotLabel(grandFinal.slots[1], matchResults)}</span>
              <span className="de-score">0–0</span>
            </div>
            {isAdmin ? (
              <button
                className="de-match__button"
                type="button"
                onClick={() => onSelectMatchWinner(grandFinal.id, 1, getSlotLabel(grandFinal.slots[1], matchResults), getSlotLabel(grandFinal.slots[0], matchResults))}
              >
                Win
              </button>
            ) : (
              <button
                className="de-match__button"
                type="button"
                disabled
                style={{ opacity: 0.5, cursor: 'not-allowed' }}
              >
                Win
              </button>
            )}
          </div>
        </div>
        <div className="de-final-card de-final-card--reset">
          <h4>Reset Final</h4>
          <div className="de-match de-match--reset">
            <div className="de-match__meta">
              <span>{resetFinal.id}</span>
              <small>BO5</small>
            </div>
            <div className="de-match__player">
              <span>{getSlotLabel(resetFinal.slots[0], matchResults)}</span>
              <span className="de-score">--</span>
            </div>
            {isAdmin ? (
              <button
                className="de-match__button"
                type="button"
                onClick={() => onSelectMatchWinner(resetFinal.id, 0, getSlotLabel(resetFinal.slots[0], matchResults), getSlotLabel(resetFinal.slots[1], matchResults))}
              >
                Win
              </button>
            ) : (
              <button
                className="de-match__button"
                type="button"
                disabled
                style={{ opacity: 0.5, cursor: 'not-allowed' }}
              >
                Win
              </button>
            )}
            <div className="de-match__player">
              <span>{getSlotLabel(resetFinal.slots[1], matchResults)}</span>
              <span className="de-score">--</span>
            </div>
            {isAdmin ? (
              <button
                className="de-match__button"
                type="button"
                onClick={() => onSelectMatchWinner(resetFinal.id, 1, getSlotLabel(resetFinal.slots[1], matchResults), getSlotLabel(resetFinal.slots[0], matchResults))}
              >
                Win
              </button>
            ) : (
              <button
                className="de-match__button"
                type="button"
                disabled
                style={{ opacity: 0.5, cursor: 'not-allowed' }}
              >
                Win
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

function buildPlayerNames(count) {
  return Array.from({ length: count }, (_, index) => `Player ${index + 1}`);
}

function buildDoubleEliminationStructure(playerCount, playerNames) {
  const winnerRounds = buildWinnerRounds(playerCount, playerNames);
  const loserRounds = buildLoserRounds(playerCount, winnerRounds);
  const finalMatchId = `M${winnerRounds.flatMap((r) => r.matches).length + loserRounds.flatMap((r) => r.matches).length + 1}`;
  const resetMatchId = `M${Number(finalMatchId.slice(1)) + 1}`;

  return {
    winnerRounds,
    loserRounds,
    grandFinal: {
      id: finalMatchId,
      slots: [
        { label: `Winner ${winnerRounds[winnerRounds.length - 1].matches[0].id}` },
        { label: `Winner ${loserRounds[loserRounds.length - 1].matches[0].id}` },
      ],
    },
    resetFinal: {
      id: resetMatchId,
      slots: [
        { label: `Bracket Reset — rematch if losers wins` },
        { label: `Champion decider` },
      ],
    },
  };
}

function getSlotLabel(slot, matchResults) {
  if (slot.label) {
    return slot.label;
  }

  const matchResult = matchResults[slot.from];
  if (!matchResult) {
    return `${slot.type === 'loser' ? 'Loser' : 'Winner'} ${slot.from}`;
  }

  return slot.type === 'loser' ? matchResult.loserLabel : matchResult.winnerLabel;
}

function buildBracketRecord(config) {
  const playerNames = config.playerNames?.length === config.playerCount
    ? config.playerNames
    : buildPlayerNames(config.playerCount);
  const winnerRounds = buildWinnerRounds(config.playerCount, playerNames);
  const loserRounds = buildLoserRounds(config.playerCount, winnerRounds);

  return {
    id: `bracket-${Date.now()}`,
    ...config,
    createdAt: new Date().toLocaleString(),
    playerNames,
    winnerRounds,
    loserRounds,
    singleEliminationRounds: buildSingleEliminationRounds(config.playerCount, playerNames),
    ...buildDoubleEliminationStructure(config.playerCount, playerNames),
  };
}

export function BracketPage() {
  const { brackets, saveBracket, updateBracket, deleteBracket, fetchRegistrations, fetchBrackets, isAuthenticated } = useAdmin();

  const params = new URLSearchParams(window.location.search);
  const queryToken = params.get("token");
  const queryGame = params.get("game");

  const token = queryToken || (isAuthenticated ? useAdmin().authToken : null);
  const isAdmin = isAuthenticated && !queryToken;

  const initialBracketConfig = {
    title: queryGame ? `${queryGame} Bracket` : "Tekken 8 Single Elimination",
    game: queryGame || "Tekken 8",
    playerCount: 64,
    bracketType: "single", // "single" or "double"
    playerNames: buildPlayerNames(64),
  };

  const [bracketConfig, setBracketConfig] = useState(initialBracketConfig);
  const [activeBracket, setActiveBracket] = useState(null);
  const [successMessage, setSuccessMessage] = useState("");
  const [registeredPlayers, setRegisteredPlayers] = useState([]);
  const [loadingPlayers, setLoadingPlayers] = useState(false);
  const [localBrackets, setLocalBrackets] = useState([]);
  const [tokenValid, setTokenValid] = useState(true);
  const [tokenError, setTokenError] = useState("");

  const updateBracketConfig = (changes) => {
    setBracketConfig((current) => ({
      ...current,
      ...changes,
    }));
  };

  // Fetch all brackets for user viewing if in public mode
  useEffect(() => {
    if (!token) return;
    const loadAllBrackets = async () => {
      try {
        const fetched = await fetchBrackets(token);
        setLocalBrackets(fetched);
        setTokenValid(true);
        setTokenError("");
      } catch (err) {
        console.error("Failed to load brackets list:", err);
        setTokenValid(false);
        setTokenError(err.message || "Invalid or expired token");
      }
    };
    loadAllBrackets();
  }, [token, fetchBrackets]);

  const activeBracketsList = isAdmin ? brackets : localBrackets;

  // When brackets are loaded and a game query param is present, automatically activate the latest bracket for that game
  useEffect(() => {
    if (queryGame && activeBracketsList && activeBracketsList.length > 0) {
      const normalize = (g) => g.replace(/\s+/g, '').toLowerCase();
      const cleanGame = normalize(queryGame);
      const gameBrackets = activeBracketsList.filter(
        (b) => normalize(b.game) === cleanGame || b.game.toLowerCase().includes(queryGame.toLowerCase())
      );
      if (gameBrackets.length > 0) {
        setActiveBracket(gameBrackets[0]);
      }
    }
  }, [activeBracketsList, queryGame]);

  // Fetch real registered players from the backend when the selected game changes
  useEffect(() => {
    if (!token) return;
    let active = true;
    const loadPlayers = async () => {
      setLoadingPlayers(true);
      try {
        const list = await fetchRegistrations(bracketConfig.game, token);
        if (active) {
          const names = list.map((reg) => reg.ign || reg.fullName);
          setRegisteredPlayers(names);
          
          // Seed the names, fill empty slots with placeholders
          const seededNames = Array.from(
            { length: bracketConfig.playerCount },
            (_, index) => names[index] || `Bye ${index + 1}`
          );
          setBracketConfig((current) => ({
            ...current,
            playerNames: seededNames,
          }));
        }
      } catch (err) {
        console.error("Failed to load registered players:", err);
      } finally {
        if (active) setLoadingPlayers(false);
      }
    };
    loadPlayers();
    return () => {
      active = false;
    };
  }, [bracketConfig.game, bracketConfig.playerCount, fetchRegistrations, token]);

  const winnerRounds = useMemo(() => {
    if (!activeBracket) return [];
    return buildWinnerRounds(activeBracket.playerCount, activeBracket.playerNames);
  }, [activeBracket]);

  const loserRounds = useMemo(() => {
    if (!activeBracket) return [];
    return buildLoserRounds(activeBracket.playerCount, winnerRounds);
  }, [activeBracket, winnerRounds]);

  const singleEliminationRounds = useMemo(() => {
    if (!activeBracket) return [];
    return buildSingleEliminationRounds(activeBracket.playerCount, activeBracket.playerNames);
  }, [activeBracket]);

  const doubleEliminationFinals = useMemo(() => {
    if (!activeBracket) return null;
    return buildDoubleEliminationStructure(activeBracket.playerCount, activeBracket.playerNames);
  }, [activeBracket]);

  const handleGenerateBracket = async () => {
    if (!isAdmin) return;
    try {
      const generated = buildBracketRecord(bracketConfig);
      const saved = await saveBracket({
        title: generated.title,
        game: generated.game,
        playerCount: generated.playerCount,
        bracketType: generated.bracketType,
        playerNames: generated.playerNames,
        matchResults: {},
      });
      setActiveBracket(saved);
      const typeLabels = {
        single: 'Single Elimination',
        'winner-only': 'Winner Bracket',
        'loser-only': 'Loser Bracket',
        double: 'Double Elimination'
      };
      setSuccessMessage(`✓ ${typeLabels[bracketConfig.bracketType]} bracket generated and saved permanently!`);
      setTimeout(() => setSuccessMessage(""), 3000);
    } catch (err) {
      alert(err.message || "Failed to generate and save bracket");
    }
  };

  const handleSelectMatchWinner = async (matchId, winnerIndex, winnerLabel, loserLabel) => {
    if (!isAdmin || !activeBracket) return;
    const currentResults = activeBracket.matchResults || {};
    const resultsObj = currentResults instanceof Map ? Object.fromEntries(currentResults) : { ...currentResults };
    const updatedResults = {
      ...resultsObj,
      [matchId]: {
        winnerIndex,
        winnerLabel,
        loserLabel,
      },
    };

    // Update locally first for snappy UI response
    setActiveBracket((prev) => ({
      ...prev,
      matchResults: updatedResults,
    }));

    try {
      await updateBracket(activeBracket.id || activeBracket._id, {
        matchResults: updatedResults,
      });
    } catch (err) {
      console.error("Failed to update bracket match results:", err);
    }
  };

  // Block loading if there is no authorization token or if token is invalid
  if (!token || !tokenValid) {
    return (
      <div style={{ padding: '40px 20px', textAlign: 'center', background: '#0a0f1d', minHeight: '100vh', display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
        <div style={{ maxWidth: '400px', background: 'rgba(255, 75, 75, 0.05)', border: '1px solid rgba(255, 75, 75, 0.2)', borderRadius: '12px', padding: '32px' }}>
          <span style={{ fontSize: '48px', display: 'block', marginBottom: '16px' }}>🔒</span>
          <h2 style={{ color: '#ff4b4b', margin: '0 0 12px 0' }}>Access Denied</h2>
          <p style={{ color: '#a6c9ea', margin: 0, lineHeight: '1.5' }}>
            {tokenError || "Authorization token is required to view brackets. Please access through the mobile app."}
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="page-grid">
      <PageIntro
        title={isAdmin ? "Bracket Designer" : "Tournament Bracket"}
        description={isAdmin ? "BracketFights-style preview with player count selection and separate winner / loser flows." : "View live tournament flows and match outcomes."}
      />

      {isAdmin && (
        <Panel
          title="Bracket Designer"
          subtitle="Create and customize tournament brackets with winner and loser brackets."
        >
          <div className="bracket-builder">
            <form className="bracket-builder__config">
              <Field label="Bracket Title">
                <input
                  value={bracketConfig.title}
                  onChange={(event) =>
                    updateBracketConfig({
                      title: event.target.value,
                    })
                  }
                  placeholder="Tekken 8 Double Elimination"
                  disabled={!isAdmin}
                />
              </Field>

              <div className="form-split">
                <Field label="Game">
                  <select
                    value={bracketConfig.game}
                    onChange={(event) =>
                      updateBracketConfig({
                        game: event.target.value,
                      })
                    }
                    disabled={!isAdmin}
                  >
                    <option>Tekken 8</option>
                    <option>FC 26</option>
                    <option>Valorant</option>
                    <option>PubG Mobile</option>
                  </select>
                </Field>

                <Field label="Player Quantity">
                  <select
                    value={bracketConfig.playerCount}
                    onChange={(event) => {
                      const nextCount = Number(event.target.value);
                      updateBracketConfig({
                        playerCount: nextCount,
                      });
                    }}
                    disabled={!isAdmin}
                  >
                    {BRACKET_OPTIONS.map((option) => (
                      <option key={option.value} value={option.value}>
                        {option.label}
                      </option>
                    ))}
                  </select>
                </Field>
              </div>

              <Field label="Bracket Type">
                <select
                  value={bracketConfig.bracketType}
                  onChange={(event) =>
                    updateBracketConfig({
                      bracketType: event.target.value,
                    })
                  }
                  disabled={!isAdmin}
                >
                  <option value="single">Single Elimination</option>
                  <option value="winner-only">Winner Bracket Only</option>
                  <option value="loser-only">Loser Bracket Only</option>
                  <option value="double">Double Elimination (Both)</option>
                </select>
              </Field>

              <Field label="Registered Players Info">
                <div style={{ marginTop: '8px', padding: '12px', background: 'rgba(255,255,255,0.03)', borderRadius: '6px' }}>
                  {loadingPlayers ? (
                    <p style={{ color: '#17b7ff', margin: 0 }}>Loading app registrations...</p>
                  ) : (
                    <p style={{ margin: 0, color: '#a6c9ea' }}>
                      Found <strong>{registeredPlayers.length}</strong> players registered from the app for {bracketConfig.game}.
                    </p>
                  )}
                </div>
              </Field>

              <Field label="Edit player names">
                <div className="player-name-grid">
                  {bracketConfig.playerNames.map((playerName, index) => (
                    <div className="player-name-row" key={index}>
                      <span>{index + 1}</span>
                      <input
                        value={playerName}
                        onChange={(event) => {
                          const nextName = event.target.value.trim() || `Player ${index + 1}`;
                          setBracketConfig((current) => {
                            const nextNames = [...current.playerNames];
                            nextNames[index] = nextName;
                            return {
                              ...current,
                              playerNames: nextNames,
                            };
                          });
                        }}
                        placeholder={`Player ${index + 1}`}
                        disabled={!isAdmin}
                      />
                    </div>
                  ))}
                </div>
                <p className="field__hint">Edit each seeded player name directly. Leave blank to keep the default label.</p>
              </Field>
            </form>

            <div className="bracket-builder__summary">
              <div className="bracket-summary-card">
                <p className="eyebrow">Format</p>
                <strong>{bracketConfig.title}</strong>
                <span>
                  {bracketConfig.bracketType === 'single' && 'Single Elimination'}
                  {bracketConfig.bracketType === 'winner-only' && 'Winner Bracket Only'}
                  {bracketConfig.bracketType === 'loser-only' && 'Loser Bracket Only'}
                  {bracketConfig.bracketType === 'double' && 'Double Elimination'}
                  {' '}- {bracketConfig.game}
                </span>
              </div>
              <div className="bracket-summary-card">
                <p className="eyebrow">Entrants</p>
                <strong>{bracketConfig.playerCount}</strong>
                <span>{BRACKET_OPTIONS.find((item) => item.value === bracketConfig.playerCount)?.entryLabel} seeding</span>
              </div>
              <div className="bracket-summary-card">
                <p className="eyebrow">Flow</p>
                {bracketConfig.bracketType === 'single' && (
                  <>
                    <strong>{buildSingleEliminationRounds(bracketConfig.playerCount, bracketConfig.playerNames).length}</strong>
                    <span>Rounds to champion</span>
                  </>
                )}
                {bracketConfig.bracketType === 'winner-only' && (
                  <>
                    <strong>{buildWinnerRounds(bracketConfig.playerCount, bracketConfig.playerNames).length}</strong>
                    <span>Winner bracket rounds</span>
                  </>
                )}
                {bracketConfig.bracketType === 'loser-only' && (
                  <>
                    <strong>{buildLoserRounds(bracketConfig.playerCount, buildWinnerRounds(bracketConfig.playerCount, bracketConfig.playerNames)).length}</strong>
                    <span>Loser bracket rounds</span>
                  </>
                )}
                {bracketConfig.bracketType === 'double' && (
                  <>
                    <strong>{buildWinnerRounds(bracketConfig.playerCount, bracketConfig.playerNames).length}W / {buildLoserRounds(bracketConfig.playerCount, buildWinnerRounds(bracketConfig.playerCount, bracketConfig.playerNames)).length}L</strong>
                    <span>Winner and loser brackets</span>
                  </>
                )}
              </div>
            </div>

            <div className="bracket-actions">
              <button type="button" className="primary-button" onClick={handleGenerateBracket} disabled={!isAdmin}>
                ✓ Generate Bracket
              </button>
              {successMessage && (
                <div className="success-message" style={{ color: '#17b7ff', marginTop: '10px' }}>{successMessage}</div>
              )}
            </div>
          </div>
        </Panel>
      )}

      <Panel
        title={activeBracket ? activeBracket.title : "Live Bracket Canvas"}
        subtitle={activeBracket ? `${activeBracket.game} - ${activeBracket.playerCount} Players` : "No active bracket selected"}
      >
        <div className="bracket-preview" style={{ padding: 0 }}>
          {!activeBracket ? (
            <div className="bracket-preview__empty">
              <p className="eyebrow">No bracket active</p>
              <p>{isAdmin ? "Select a saved bracket from the list below, or click Generate Bracket to start a new one." : "No bracket is currently generated for this game."}</p>
            </div>
          ) : (
            <>
              <div className="bracket-preview__hero">
                <div>
                  <p className="eyebrow">live bracket canvas</p>
                  <h2>{activeBracket.title}</h2>
                  <p>
                    {activeBracket.playerCount} players - {
                      activeBracket.bracketType === 'single' ? 'Single Elimination' :
                      activeBracket.bracketType === 'winner-only' ? 'Winner Bracket Only' :
                      activeBracket.bracketType === 'loser-only' ? 'Loser Bracket Only' :
                      'Double Elimination'
                    } format
                  </p>
                </div>
                <StatusBadge value={`${activeBracket.playerCount} Players`} />
              </div>

              {activeBracket.bracketType === 'single' && (
                <SingleEliminationBracket
                  rounds={singleEliminationRounds}
                  playerNames={activeBracket.playerNames}
                  matchResults={activeBracket.matchResults || {}}
                  onSelectMatchWinner={handleSelectMatchWinner}
                  isAdmin={isAdmin}
                />
              )}

              {activeBracket.bracketType === 'double' && doubleEliminationFinals && (
                <DoubleEliminationBracket
                  winnerRounds={winnerRounds}
                  loserRounds={loserRounds}
                  playerNames={activeBracket.playerNames}
                  grandFinal={doubleEliminationFinals.grandFinal}
                  resetFinal={doubleEliminationFinals.resetFinal}
                  matchResults={activeBracket.matchResults || {}}
                  onSelectMatchWinner={handleSelectMatchWinner}
                  isAdmin={isAdmin}
                />
              )}

              {activeBracket.bracketType === 'winner-only' && (
                <BracketBoard
                  title="Winner Bracket"
                  eyebrow="upper side"
                  rounds={winnerRounds}
                  tone="winner"
                />
              )}

              {activeBracket.bracketType === 'loser-only' && (
                <BracketBoard
                  title="Loser Bracket"
                  eyebrow="lower side"
                  rounds={loserRounds}
                  tone="loser"
                  compact
                />
              )}
            </>
          )}
        </div>
      </Panel>

      {isAdmin && activeBracketsList && activeBracketsList.length > 0 && (
        <Panel
          title="Generated & Saved Brackets"
          subtitle={`${activeBracketsList.length} saved bracket configuration${activeBracketsList.length !== 1 ? 's' : ''}`}
        >
          <div className="brackets-list" style={{ display: 'grid', gap: '12px' }}>
            {activeBracketsList.map((bracket) => (
              <div 
                className={`bracket-item ${activeBracket?.id === bracket.id ? 'bracket-item--active' : ''}`} 
                key={bracket.id}
                style={{
                  cursor: 'pointer',
                  border: activeBracket?.id === bracket.id ? '2px solid #17b7ff' : '1px solid rgba(255,255,255,0.1)',
                  padding: '16px',
                  borderRadius: '8px',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  background: activeBracket?.id === bracket.id ? 'rgba(23, 183, 255, 0.05)' : 'rgba(255,255,255,0.02)'
                }}
                onClick={() => setActiveBracket(bracket)}
              >
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', alignItems: 'center' }}>
                    <div>
                      <strong style={{ fontSize: '1.1rem', color: '#fff' }}>{bracket.title}</strong>
                      <p style={{ margin: '4px 0 0 0', color: '#a6c9ea', fontSize: '0.9rem' }}>{bracket.game}</p>
                    </div>
                    <div style={{ textAlign: 'right' }}>
                      <span style={{ background: 'rgba(23,183,255,0.1)', color: '#17b7ff', padding: '2px 8px', borderRadius: '4px', fontSize: '0.8rem' }}>{bracket.playerCount} Players</span>
                      <span style={{ display: 'block', color: 'rgba(255,255,255,0.4)', fontSize: '0.8rem', marginTop: '4px' }}>{new Date(bracket.createdAt).toLocaleString()}</span>
                    </div>
                  </div>
                </div>
                <div style={{ marginLeft: '16px' }} onClick={(e) => e.stopPropagation()}>
                  <button
                    className="danger-button"
                    style={{
                      background: 'rgba(255, 75, 75, 0.1)',
                      color: '#ff4b4b',
                      border: '1px solid rgba(255, 75, 75, 0.2)',
                      padding: '6px 12px',
                      borderRadius: '4px',
                      cursor: 'pointer'
                    }}
                    onClick={async () => {
                      if (!window.confirm("Delete this bracket permanently?")) return;
                      try {
                        await deleteBracket(bracket.id);
                        if (activeBracket?.id === bracket.id) {
                          setActiveBracket(null);
                        }
                      } catch (err) {
                        alert(err.message || "Failed to delete bracket");
                      }
                    }}
                  >
                    Delete
                  </button>
                </div>
              </div>
            ))}
          </div>
        </Panel>
      )}
    </div>
  );
}
