// json-server (aka express) requires RESTful APIs with a ID to be passed
// through the resource for POST to work by default. The Votes table
// isn't set up like that, so this hooks into /pitches/vote POST to
// add the UUID to the column/array of UUIDs
//
// curl -d '{"pitch_uuid":"a097c86f-bb8d-4c64-8c6a-edd5e90b157d"}' -H "Content-Type: application/json" -X POST http://localhost:3000/pitches/vote/

const fs = require('fs');
const db = require('./db.json');

module.exports = (req, res, next) => {
  if (req.originalUrl === '/pitches/vote/' && req.method === 'POST') {
    const pitchUuid = req.body['pitch_uuid'];

    // Prevent duplicate writes
    if (db.votes.indexOf(pitchUuid) === -1) {
      db.votes.push(pitchUuid);
      db.pitches.find(pitch => pitch.uuid === pitchUuid).votes++
      fs.writeFile('./json-server/db.json', JSON.stringify(db, null, 2), (err) => {
        if (err) throw err;
      });
      return res.status(200).send();
    } else {
      return res.status(501).send('Pitch UUID already exists in votes');
    }
  }

  next();
}
