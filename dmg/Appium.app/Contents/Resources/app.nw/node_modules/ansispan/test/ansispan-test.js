var assert = require('assert'),
    vows = require('vows'),
    ansispan = require('../');

require('colors');

var dataSets = {
  simple: {
    input: 'hello world'.green,
    output: '<span style="color: green">hello world</span>'
  },
  nested: {
    input: 'hello world'.green.red,
    output: '<span style="color: red"><span style="color: green">hello world</span></span>'
  },
  many: {
    input: 'hello '.green + 'world'.red,
    output: '<span style="color: green">hello </span><span style="color: red">world</span>'
  },
  'many same colors': {
    input: 'hello '.green + 'world'.green,
    output: '<span style="color: green">hello </span><span style="color: green">world</span>'
  },
  'colors with \\033\\[0;Xm': {
    input: '\033\[0;32mhello world\033\[39m',
    output: '<span style="color: green">hello world</span>'
  },
  'colors with reset bit': {
    input: '\033[35mhello world\033[0m',
    output: '<span style="color: purple">hello world</span>'
  },
  bold: {
    input: 'hello world'.bold,
    output: '<b>hello world</b>'
  },
  italics: {
    input: 'hello world'.italic,
    output: '<i>hello world</i>'
  }
};

function getTopics() {
  var topics = {};
  Object.keys(dataSets).forEach(function (set) {
    topics['when using ' + set + ' data set'] = {
      topic: ansispan(dataSets[set].input),
      'should return correct output': function (result) {
        assert.isString(result);
        assert.equal(result, dataSets[set].output);
      }
    };
  });
  return topics;
}

vows.describe('ansispan').addBatch({
  'When using ansispan': getTopics()
}).export(module);

