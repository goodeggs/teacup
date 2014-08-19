#!/bin/sh

./node_modules/.bin/coffee -mco lib src
./node_modules/.bin/uglifyjs -m -c -o lib/teacup.min.js lib/teacup.js
