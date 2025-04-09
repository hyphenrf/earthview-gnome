#!/usr/bin/env bash

EXTENSION_NAME=GoogleEarthWallpaper@neffo.github.com
ZIP_NAME=$EXTENSION_NAME.zip

# stop build if this doesn't work
npm --version && (npm test; if [ $? -ne 0 ]; then exit 1; fi)

glib-compile-schemas schemas/
intltool-extract --type=gettext/glade ui/Settings.ui 
intltool-extract --type=gettext/glade ui/Settings4.ui
xgettext -k -k_ -kN_ --omit-header -o locale/GoogleEarthWallpaper.pot ui/Settings.ui.h ui/Settings4.ui.h extension.js prefs.js utils.js --from-code=UTF-8

rm -f translations.txt
for D in locale/*; do
    if [ -d "${D}" ]; then
        msgfmt --statistics --template=locale/GoogleEarthWallpaper.pot --verbose -o "${D}/LC_MESSAGES/GoogleEarthWallpaper.mo" "${D}/LC_MESSAGES/GoogleEarthWallpaper.po" 2>> translations.txt  # compile translations
    fi
done

rm -f $ZIP_NAME

zip -r $ZIP_NAME * -x screenshot/\* \*.py \*~ \*.sh .\* translations.txt \*.h package\*.json \*.po \*.pot node_modules/\* eslint*

