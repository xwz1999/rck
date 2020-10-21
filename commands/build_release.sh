echo "BUILD RELEASE"
flutter clean
echo "build android apk"
flutter build apk
echo "build iOS"
flutter build ios 