#!/bin/bash

for plist in ./Carthage/Build/iOS/*/*.plist ; do
  if [ -e "$plist" ] ; then   # Check whether file exists.
     plutil -replace 'CFBundleShortVersionString' -string $1 $plist
  fi
done
