# UUID-js

A js library to generate and parse UUID's, TimeUUID's and generate empty TimeUUID's based on TimeStamp for range selections.

```javascript
var UUID = require('uuid-js');


// Generate a V4 UUID
var uuid4 = UUID.create();
console.log(uuid4.toString());
// Prints: 896b677f-fb14-11e0-b14d-d11ca798dbac


// Generate a V1 TimeUUID
var uuid1 = UUID.create(1);
console.log(uuid1.toString());


// First and last possible v1 TimeUUID for a given timestamp:
var date = new Date().getTime();
var uuidFirst = UUID.fromTime(date, false);
var uuidLast = UUID.fromTime(date, true);
console.log(uuidFirst.toString(), uuidLast.toString());
// Prints: aa0f9af0-0e1f-11e1-0000-000000000000 aa0f9af0-0e1f-11e1-c0ff-ffffffffffff


// Use these TimeUUID's to perform range queries in cassandra:
var today = new Date().getTime();
var last30days = (new Date().setDate( today.getDate() - 30 )).getTime();

var rangeStart = UUID.firstFromTime(last30days);
var rangeEnd = UUID.lastFromTime(today);

var query = ...("select first 50 reversed ?..? from user_twits where key=?", [ rangeStart, rangeEnd, "patricknegri" ]);
```


## Instalation

```
$ npm install uuid-js
```

## Functions List

These are available just with require and return an instance of the UUID object:

```javascript
UUID.create(4); // Generate V4 UUID

UUID.create(1); // Generate V1 TimeUUID

UUID.fromTime(time, last); // Generate a V1 empty TimeUUID from a Date object (Ex: new Date().getTime() )

UUID.firstFromTime(time); // Same as fromTime but first sequence

UUID.lastFromTime(time); // Same as fromTime but last sequence

UUID.fromURN(strId); // Generate a UUID object from string

UUID.fromBytes(ints); // Generate a UUID object from bytes

UUID.fromBinary(binary); // Generate a UUID object from binary
```

## Methods List

These must be called on an instance of the UUID object:

```javascript
uuid.fromParts(timeLow, timeMid, timeHiAndVersion, clockSeqHiAndReserved, clockSeqLow, node);

uuid.toString(); // hex string version of UUID

uuid.toURN(); // same as hex, but with urn:uuid prefix

uuid.toBytes(); // converted to an array of bytes
```

## Tests

```
make test
```

## Contributors

  * Christoph Tavan <dev@tavan.de>

This work was based RFC and by the work of these people.

  * LiosK <contact@mail.liosk.net>
  * Gary Dusbabek <gdusbabek@gmail.com>
