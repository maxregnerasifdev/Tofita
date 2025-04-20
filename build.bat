$env:Path += ";$PWD\..\Hexa"
$ErrorActionPreference = 'SilentlyContinue'

# Move to Hexa directory for building
cd ..\Hexa

# Ensure Hexa is present before starting the build process
if (-not (Test-Path "hexa.json")) {
    Write-Host "Hexa configuration file not found. Please ensure Hexa is properly set up."
    exit 1
}

# Run Hexa build
node bootstrap.js --define debug=false hexa.json
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in Hexa bootstrap build!"
    exit $LASTEXITCODE
}

# Second Hexa build step
node hexa-node.js --define debug=true --define times=false hexa.json
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in Hexa second build!"
    exit $LASTEXITCODE
}

# Final Hexa build without debug
node hexa-node.js --define debug=false --define times=false hexa.json
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in Hexa final build!"
    exit $LASTEXITCODE
}

Write-Host "Hexa build completed successfully."

# Run the Greentea build process
cd ..\Greentea

# Check if Greentea directory exists
if (-not (Test-Path "build.bat")) {
    Write-Host "Greentea build file not found. Please ensure the Greentea directory is properly set up."
    exit 1
}

# Execute the Greentea build script
cmd.exe /c 'build.bat'

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in Greentea build process!"
    exit $LASTEXITCODE
}

Write-Host "Greentea build completed successfully."

# Success message
Write-Host "Build process completed successfully!"
