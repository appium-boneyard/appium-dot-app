var UUID = require('../lib/uuid');
var assert = require('assert');
var sinon = require('sinon');
var util = require('util');

function isUUID(str) {
  return str.match(/^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/);
}

exports['Check UUID methods'] = function() {
  var methods = [
    'maxFromBits',
    'limitUI04',
    'limitUI06',
    'limitUI08',
    'limitUI12',
    'limitUI14',
    'limitUI16',
    'limitUI32',
    'limitUI40',
    'limitUI48',
    'randomUI04',
    'randomUI06',
    'randomUI08',
    'randomUI12',
    'randomUI14',
    'randomUI16',
    'randomUI32',
    'randomUI40',
    'randomUI48',
    'create',
    '_create1',
    '_create4',
    'paddedString',
    'getTimeFieldValues',
    'fromTime',
    'firstFromTime',
    'lastFromTime',
    'fromURN',
    'fromBytes',
    'fromBinary',
    // Legacy methods:
    'new',
    'newTS'
  ];
  var found = 0;
  for (var key in UUID) {
    if (methods.indexOf(key) !== -1) {
      found++;
      continue;
    }
    assert.ok(false, 'Found unexpected method: ' + key);
  }
  assert.equal(found, methods.length, 'Unexpected number of defined methods: ' + found + ' != ' + methods.length);
};

exports['Check UUID prototypes'] = function() {
  var methods = [
    'fromParts',
    'toString',
    'toURN',
    'toBytes',
    'equals'
  ];
  var found = 0;
  for (var key in UUID.prototype) {
    if (methods.indexOf(key) !== -1) {
      found++;
      continue;
    }
    assert.ok(false, 'Found unexpected prototype: ' + key);
  }
  assert.equal(found, methods.length, 'Unexpected number of defined prototypes: ' + found + ' != ' + methods.length);
};


exports['v4 UUID: uuid = UUID.create(4) -> test properties'] = function() {
  var uuid = UUID.create(4);

  var properties = [
    'version',
    'hex'
  ];
  var found = 0;
  for (var key in uuid) {
    // Filter prototypes
    if (!uuid.hasOwnProperty(key)) {
      continue;
    }
    if (properties.indexOf(key) !== -1) {
      found++;
      continue;
    }
    console.log(key);
    assert.ok(false, 'Found unexpected property in uuid instance: ' + key);
  }
  assert.equal(found, properties.length);

  assert.equal(uuid.version, 4, 'Unexpected version: ' + uuid.version);
  assert.ok(isUUID(uuid.hex), 'UUID semantically incorrect');
};


exports['v4 UUID: uuid.toString()'] = function() {
  var uuid = UUID.create(4);
  assert.equal(uuid.toString(), uuid.hex);
};


exports['v4 UUID: uuid.toURN()'] = function() {
  var uuid = UUID.create(4);
  assert.equal(uuid.toURN(), 'urn:uuid:' + uuid.hex);
};


exports['v4 UUID: uuid.toBytes()'] = function() {
  var uuid = UUID.create(4);
  var bytes = uuid.toBytes();

  // Reassemble the bytes and check if they fit the string representation
  var hex = [];
  for (var i = 0; i < bytes.length; i++) {
    hex.push(bytes[i].toString(16));
  }
  var index = 0;
  var parts = [];
  [4, 2, 2, 2, 6].forEach(function(len) {
    var part = [];
    for (var j = 0; j < len; j++) {
      var val = hex[index]+"";
      if (val.length < 2) {
        val = "0" + val;
      }
      part.push(val);
      index++;
    }
    parts.push(part.join(''));
  });
  assert.equal(uuid.hex, parts.join('-'));
};


exports['v4 UUID: check that they are not time-ordered'] = function() {
  var unsorted = [];
  var sorted = [];
  for (var i = 0; i < 100; i++) {
    var uuid = UUID.create(4).toString();
    unsorted.push(uuid);
    sorted.push(uuid);
  }
  sorted.sort();
  assert.notDeepEqual(sorted, unsorted, 'v4 UUIDs appear to be sorted!');
};


exports['v1 UUID: uuid = UUID.create(1) -> test properties'] = function() {
  var uuid = UUID.create(1);

  var properties = [
    'version',
    'hex'
  ];
  var found = 0;
  for (var key in uuid) {
    // Filter prototypes
    if (!uuid.hasOwnProperty(key)) {
      continue;
    }
    if (properties.indexOf(key) !== -1) {
      found++;
      continue;
    }
    assert.ok(false, 'Found unexpected property in uuid instance: ' + key);
  }
  assert.equal(found, properties.length);

  assert.equal(uuid.version, 1, 'Unexpected version: ' + uuid.version);
  assert.ok(isUUID(uuid.hex), 'UUID semantically incorrect');
};


exports['v1 UUID: uuid.toString()'] = function() {
  var uuid = UUID.create(1);
  assert.equal(uuid.toString(), uuid.hex);
};


exports['v1 UUID: uuid.toURN()'] = function() {
  var uuid = UUID.create(1);
  assert.equal(uuid.toURN(), 'urn:uuid:' + uuid.hex);
};


exports['v1 UUID: uuid.toBytes()'] = function() {
  var uuid = UUID.create(1);
  var bytes = uuid.toBytes();

  // Reassemble the bytes and check if they fit the string representation
  var hex = [];
  for (var i = 0; i < bytes.length; i++) {
    hex.push(bytes[i].toString(16));
  }
  var index = 0;
  var parts = [];
  [4, 2, 2, 2, 6].forEach(function(len) {
    var part = [];
    for (var j = 0; j < len; j++) {
      var val = hex[index]+"";
      if (val.length < 2) {
        val = "0" + val;
      }
      part.push(val);
      index++;
    }
    parts.push(part.join(''));
  });
  assert.equal(uuid.hex, parts.join('-'));
};


exports['v1 UUID: check that they are time-ordered'] = function() {
  var unsorted = [];
  var sorted = [];
  var check = function() {
    sorted.sort();
    assert.deepEqual(sorted, unsorted, 'v1 UUIDs appear not to be sorted!');
  };
  var i = 0;
  // We have to wait a tiny bit between generating two UUIDs to assure time
  // order since times are based on milliseconds and two UUIDs created in
  // the same millisecond need not be different.
  var next = function() {
    var uuid = UUID.create(1).toString();
    unsorted.push(uuid);
    sorted.push(uuid);
    i++;
    if (i < 100) {
      return setTimeout(next, 5);
    }
    check();
  };
  next();
};


exports['firstFromTime()'] = function() {
  var date = new Date();
  date = date.getTime();
  var spy = sinon.spy(UUID, 'fromTime');

  var uuid = UUID.firstFromTime(date);
  assert.ok(spy.calledOnce);
  assert.ok(spy.calledWith(date, false));
  assert.ok(isUUID(uuid.toString()), 'UUID semantically incorrect');

  spy.restore();
};


exports['lastFromTime()'] = function() {
  var date = new Date();
  date = date.getTime();
  var spy = sinon.spy(UUID, 'fromTime');

  var uuid = UUID.lastFromTime(date);
  assert.ok(spy.calledOnce);
  assert.ok(spy.calledWith(date, true));
  assert.ok(isUUID(uuid.toString()), 'UUID semantically incorrect');

  spy.restore();
};


exports['fromTime()'] = function() {
  var date = new Date();
  date = date.getTime();

  var uuidFirst = UUID.fromTime(date, false);
  var uuidLast = UUID.fromTime(date, true);

  assert.strictEqual(uuidFirst.toString().substr(0, 19), uuidLast.toString().substr(0, 19), 'Timestamp part of first and last not equal');
};


exports['create(1) -> _create1()'] = function() {
  var spy = sinon.spy(UUID, '_create1');
  var uuid = UUID.create(1);
  assert.ok(spy.calledOnce);
  spy.restore();
};


exports['create(4) -> _create4()'] = function() {
  var spy = sinon.spy(UUID, '_create4');
  var uuid = UUID.create(4);
  assert.ok(spy.calledOnce);
  spy.restore();
};


exports['create() -> create4()'] = function() {
  var spy = sinon.spy(UUID, '_create4');
  var uuid = UUID.create();
  assert.ok(spy.calledOnce);
  spy.restore();
};


exports['new() alias for create(4)'] = function() {
  var spy = sinon.spy(UUID, 'create');

  var uuid = UUID.new();

  assert.ok(spy.calledOnce);
  assert.ok(spy.calledWith(4));

  spy.restore();
};


exports['newTS() alias for create(1)'] = function() {
  var spy = sinon.spy(UUID, 'create');

  var uuid = UUID.new();

  assert.ok(spy.calledOnce);
  assert.ok(spy.calledWith(4));

  spy.restore();
};


for (var key in exports) {
  exports[key]();
  console.log('✔ ' + key);
}
