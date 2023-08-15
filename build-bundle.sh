# Build App
cd src
flutter build linux
cd ..

mkdir -p rechnungs-assistent-bundle
# Copy relevant files to zip
cp -r src/build/linux/x64/release/bundle/* rechnungs-assistent-bundle
cp src/generator.py rechnungs-assistent-bundle
cp src/runner.py rechnungs-assistent-bundle
cp -r src/latex rechnungs-assistent-bundle

zip -r rechnungs-assistent-bundle.zip rechnungs-assistent-bundle