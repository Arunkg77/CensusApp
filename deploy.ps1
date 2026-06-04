# deploy.ps1
# Script to build and deploy the Flutter Web application to GitHub Pages manually

# Exit immediately if a command fails
$ErrorActionPreference = "Stop"

Write-Host "1. Cleaning and building Flutter Web app with base href /CensusApp/..." -ForegroundColor Cyan
flutter clean
flutter pub get
flutter build web --base-href "/CensusApp/"

Write-Host "2. Navigating to build output..." -ForegroundColor Cyan
cd build/web

Write-Host "3. Initializing temporary Git repo in build/web..." -ForegroundColor Cyan
git init
git checkout -b gh-pages

Write-Host "4. Adding files and committing..." -ForegroundColor Cyan
git add .
git commit -m "Manual deployment to GitHub Pages"

Write-Host "5. Force pushing to GitHub Pages branch..." -ForegroundColor Cyan
git remote add origin https://github.com/Arunkg77/CensusApp.git
git push -f origin gh-pages

Write-Host "Successfully built and deployed!" -ForegroundColor Green
