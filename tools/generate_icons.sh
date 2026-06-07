#!/bin/bash
set -e

SRC="WhatsApp Image 2026-04-18 at 22.04.16.jpeg"

# Android App Icons
convert "$SRC" -resize 48x48 android/app/src/main/res/mipmap-mdpi/ic_launcher.png
convert "$SRC" -resize 72x72 android/app/src/main/res/mipmap-hdpi/ic_launcher.png
convert "$SRC" -resize 96x96 android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
convert "$SRC" -resize 144x144 android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
convert "$SRC" -resize 192x192 android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

# Android Splash Logo (centered, large)
convert "$SRC" -resize 512x512 android/app/src/main/res/drawable/splash_logo.png
convert "$SRC" -resize 512x512 android/app/src/main/res/drawable-v21/splash_logo.png

# iOS Launch Images
convert "$SRC" -resize 414x896 ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png
convert "$SRC" -resize 828x1792 ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
convert "$SRC" -resize 1242x2688 ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png

# iOS App Icons
convert "$SRC" -resize 40x40 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png
convert "$SRC" -resize 60x60 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png
convert "$SRC" -resize 29x29 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png
convert "$SRC" -resize 58x58 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png
convert "$SRC" -resize 87x87 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png
convert "$SRC" -resize 80x80 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png
convert "$SRC" -resize 120x120 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png
convert "$SRC" -resize 120x120 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png
convert "$SRC" -resize 180x180 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png
convert "$SRC" -resize 20x20 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png
convert "$SRC" -resize 40x40 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png
convert "$SRC" -resize 29x29 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png
convert "$SRC" -resize 58x58 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png
convert "$SRC" -resize 40x40 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png
convert "$SRC" -resize 80x80 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png
convert "$SRC" -resize 76x76 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png
convert "$SRC" -resize 152x152 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png
convert "$SRC" -resize 167x167 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png
convert "$SRC" -resize 1024x1024 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png

echo "Done!"
