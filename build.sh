#! /bin/sh

# Do this manually for now:
# 1) cd app
# 2) npm install

rm -rf ./build/Appium.app/Contents/Resources/app.nw
cp -R app ./build/Appium.app/Contents/Resources/app.nw
