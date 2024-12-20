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
chmod +x deb/usr/bin/rechnungs-assistent
chmod 755 deb/DEBIAN

# Estimate the installed size by summing the sizes of all files in the deb directory
SIZE=$(du -s deb | cut -f1)
sed -i "s/Installed-Size: .*/Installed-Size: $SIZE/" deb/DEBIAN/control

# Build deb package
sed -i "2s/.*/Version: $VERSION/" deb/DEBIAN/control
dpkg-deb --build -Zxz --root-owner-group deb
mv deb.deb rechnungs-assistent_$VERSION.deb