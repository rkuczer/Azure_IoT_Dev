#!/bin/bash
set -e

# Set the path to the X509Sample project
PROJECT_PATH="azure-iot-sdk-csharp/provisioning/device/samples/getting-started/X509Sample/X509Sample.csproj"

# Verify that the project file exists
if [ ! -f "$PROJECT_PATH" ]; then
  echo "Error: Project file $PROJECT_PATH does not exist."
  exit 1
fi

# Restore the .NET dependencies
echo "Restoring .NET dependencies for $PROJECT_PATH..."
dotnet restore "$PROJECT_PATH"

# Build the project
echo "Building the project..."
dotnet build "$PROJECT_PATH"

# Optionally run the project (you can uncomment the line below if needed)
# echo "Running the project..."
# dotnet run --project "$PROJECT_PATH" -- -s <id-scope> -c <path-to-certificate>.pfx -p <pfx-password>

echo "Process completed successfully."
