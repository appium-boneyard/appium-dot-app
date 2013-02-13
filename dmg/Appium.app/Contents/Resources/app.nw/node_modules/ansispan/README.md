# ansispan [![Build Status](https://secure.travis-ci.org/mmalecki/ansispan.png)](http://travis-ci.org/mmalecki/ansispan)
Copyright (C) 2011 by Maciej Małecki  
MIT License (see LICENSE file)

Change your ANSI color codes into HTML `<span>`s

## Installation

    npm install ansispan

## Usage

```javascript
var ansispan = require('ansispan');
require('colors');

ansispan('green!'.green); // => '<span style="color: green">green!</span>'
```

