VERSION="$( cat version )"

# Build App
cd src
flutter build linux
cd ..

# Download the latest chromium build if chhrome-linux.zip is not present
if [ ! -f "chrome-linux.zip" ]; then
    curl https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/1192875/chrome-linux.zip > chrome-linux.zip
fi
unzip chrome-linux.zip

# Delete old bundle if present
if [ -d "rechnungs-assistent-bundle" ]; then
    rm -r rechnungs-assistent-bundle
fi

mkdir -p rechnungs-assistent-bundle
mv chrome-linux rechnungs-assistent-bundle/chromium
# Copy relevant files to zip
cp -r src/build/linux/x64/release/bundle/* rechnungs-assistent-bundle
cp src/generator-html.py rechnungs-assistent-bundle
cp -r src/html rechnungs-assistent-bundle
cp deb/usr/bin/rechnungs-assistent rechnungs-assistent-bundle/rechnungs-assistent.sh
# Remove the line "cd /usr/lib/rechnungs-assistent" in rechnungs-assistent-bundle/rechnungs-assistent.sh
sed -i 's|cd /usr/lib/rechnungs-assistent||g' rechnungs-assistent-bundle/rechnungs-assistent.sh

# Delete old zip if present
if [ -f "rechnungs-assistent-bundle-$VERSION.zip" ]; then
    rm rechnungs-assistent-bundle-$VERSION.zip
fi
zip -r rechnungs-assistent-bundle-$VERSION.zip rechnungs-assistent-bundle