#! /bin/sh

git pull
cd app
rm -rf ./node_modules
npm install
cd ..
rm -rf ./build/Appium.app/Contents/Resources/app.nw
cp -R app ./build/Appium.app/Contents/Resources/app.nw
