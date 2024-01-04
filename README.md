# Rechnungs-Assistent

## Erstelle Rechnungen im Handumdrehen

![invoices.png](invoices.png)

Rechnungs-Assistent für vorwiegend Selbstständige oder kleine Unternehmen
Kunden und Artikel können auch von außen in .csv Dateien unter "Dokumente/Rechnungen/data" geschrieben werden, um diese für den Rechnungs-Assistent zu importieren.
Ebenfalls ist der Rechnungs-Assistent komplett Skript fähig, dazu einfach `rechnungs-assistent --help` eingeben.

## How to run for development

```bash
# Install chromium to the system or put the chromium folder into the src folder
sudo apt install chromium 

# Flutter:
sudo apt install snapd
snap install flutter --classic


# First session (Frontend):
cd src
flutter run
```

## How to build deb package

```bash
bash build-deb.sh
```

## How to build the bundle

```bash
bash build-bundle.sh
```

## How to build flatpak package (work in progress)

It uses the bundle.zip of the release specified in the .yml file

```bash
flatpak-builder build-dir de.linuxguides.RechnungsAssistent.yml  --user --force-clean --install
flatpak run de.linuxguides.RechnungsAssistent
#flatpak --filesystem=host run de.linuxguides.RechnungsAssistent # For access to all files
```
