// json-server (aka express) requires RESTful APIs with a ID to be passed
// through the resource for DELETE to work by default. The Votes table
// isn't set up like that, so this hooks into /pitches/vote DELETE to
// remove the UUID from the column/array of UUIDs
//
// curl -d '{"pitch_uuid":"a097c86f-bb8d-4c64-8c6a-edd5e90b157d"}' -H "Content-Type: application/json" -X DELETE http://localhost:3000/pitches/vote/

const fs = require('fs');
const db = require('./db.json');

module.exports = (req, res, next) => {
  if (req.originalUrl === '/pitches/vote/' && req.method === 'DELETE') {
    const pitchUuid = req.body['pitch_uuid'];
    const pitchIndex = db.votes.indexOf(pitchUuid);

    // Don't accidentally remove other votes
    if (pitchIndex !== -1) {
      db.votes.splice(pitchIndex, 1);
      db.pitches.find(pitch => pitch.uuid === pitchUuid).votes--
      fs.writeFile('./json-server/db.json', JSON.stringify(db, null, 2), (err) => {
        if (err) throw err;
      });
      return res.status(200).send();
    } else {
      return res.status(501).send("Pitch UUID doesn't exist in votes");
    }
  }

  next();
}
