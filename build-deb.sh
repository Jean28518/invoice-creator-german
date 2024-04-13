#!/bin/bash
VERSION="$( cat version )"

# Build App
cd src
flutter build linux
cd ..
cp version src/build/linux/x64/release/bundle/

# Prepare deb files for packaging
mkdir -p deb/usr/lib/rechnungs-assistent/
cp -r src/build/linux/x64/release/bundle/* deb/usr/lib/rechnungs-assistent/
cp src/generator-html.py deb/usr/lib/rechnungs-assistent/
cp -r src/html deb/usr/lib/rechnungs-assistent/

# mkdir -p deb/usr/share/icons/hicolor/scalable/apps/
# cp rechnungs-assistent.svg deb/usr/share/icons/hicolor/scalable/apps/
mkdir -p deb/usr/share/icons/hicolor/256x256/apps/
cp rechnungs-assistent.png deb/usr/share/icons/hicolor/256x256/apps/
mkdir -p deb/usr/share/applications/
cp rechnungs-assistent.desktop deb/usr/share/applications/
mkdir -p deb/usr/bin/
cp rechnungs-assistent deb/usr/bin/

# chown and chmod
sudo chown -R root:root deb/
sudo chmod -R 755 deb/
sudo chmod +x deb/usr/bin/rechnungs-assistent

# Build deb package
sed -i "2s/.*/Version: $VERSION/" deb/DEBIAN/control
dpkg-deb --build -Zxz deb
mv deb.deb rechnungs-assistent_$VERSION.deb
