const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Clean up games older than 1 hour - runs every 15 minutes
exports.cleanupOldGames = functions.pubsub
  .schedule('every 15 minutes')
  .onRun(async (context) => {
    const now = Date.now();
    const oneHourAgo = now - (60 * 60 * 1000); // 1 hour in milliseconds
    
    const db = admin.database();
    const gamesRef = db.ref('games');
    
    try {
      const snapshot = await gamesRef.once('value');
      const games = snapshot.val();
      
      if (!games) {
        console.log('No games found');
        return null;
      }
      
      const deletePromises = [];
      
      Object.entries(games).forEach(([gameCode, game]) => {
        const createdAt = game.createdAt || 0;
        const players = game.players ? Object.keys(game.players) : [];
        const fiveMinutesAgo = now - (5 * 60 * 1000); // 5 minutes in ms

        // Delete if older than 1 hour (existing logic)
        if (createdAt < oneHourAgo) {
          console.log(`Deleting game ${gameCode} created at ${new Date(createdAt)} (older than 1 hour)`);
          deletePromises.push(gamesRef.child(gameCode).remove());
        // Delete if only 1 player and older than 5 minutes
        } else if (players.length === 1 && createdAt < fiveMinutesAgo) {
          console.log(`Deleting game ${gameCode} with only 1 player, created at ${new Date(createdAt)} (older than 5 minutes)`);
          deletePromises.push(gamesRef.child(gameCode).remove());
        }
      });
      
      await Promise.all(deletePromises);
      console.log(`Deleted ${deletePromises.length} old games`);
      
      return null;
    } catch (error) {
      console.error('Error cleaning up games:', error);
      return null;
    }
  });

  exports.cleanupOldWaitingGames = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    const db = admin.database();
    const now = Date.now();
    const THIRTY_MINUTES = 30 * 60 * 1000;
    const gamesRef = db.ref('games'); // Adjust path if needed

    const snapshot = await gamesRef.orderByChild('currentPhase').equalTo('waitingForPlayers').once('value');
    const updates = {};

    snapshot.forEach(child => {
      const game = child.val();
      // Assumes you store a timestamp field like 'createdAt' (in ms)
      if (game.createdAt && now - game.createdAt > THIRTY_MINUTES) {
        updates[child.key] = null; // Mark for deletion
      }
    });

    if (Object.keys(updates).length > 0) {
      await gamesRef.update(updates);
      console.log(`Deleted ${Object.keys(updates).length} old waiting games.`);
    }
    return null;
  });