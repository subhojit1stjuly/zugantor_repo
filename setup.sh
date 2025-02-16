#!/bin/bash

ERROR_COUNT=0
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "========================================"
echo "Zugantor Monorepo Setup"
echo "========================================"
echo

# Function to print status messages
print_status() {
    local type=$1
    local message=$2
    case $type in
        "SUCCESS") echo -e "${GREEN}[SUCCESS]${NC} $message" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} $message"; ((ERROR_COUNT++)) ;;
        "WARNING") echo -e "${YELLOW}[WARNING]${NC} $message"; ((ERROR_COUNT++)) ;;
    esac
}

# Check if Flutter is installed
echo "[1/5] Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_status "ERROR" "Flutter is not installed or not in PATH\nPlease install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi
flutter --version
echo

# Check if Dart is installed
echo "[2/5] Checking Dart installation..."
if ! command -v dart &> /dev/null; then
    print_status "ERROR" "Dart is not installed or not in PATH\nPlease install Dart from https://dart.dev/get-dart"
    exit 1
fi
dart --version
echo

# Install Melos globally
echo "[3/5] Installing Melos..."
if dart pub global activate melos; then
    print_status "SUCCESS" "Melos installed successfully"
else
    print_status "ERROR" "Failed to install Melos"
fi
echo

# Bootstrap and generate
echo "[4/5] Bootstrapping workspace and generating code..."
if melos bootstrap; then
    print_status "SUCCESS" "Workspace bootstrapped successfully"
    echo "Running code generation..."
    melos run generate || print_status "WARNING" "Code generation completed with warnings"
else
    print_status "ERROR" "Failed to bootstrap workspace"
fi
echo

# Format and analyze
echo "[5/5] Running format and analyze..."
melos run format || print_status "WARNING" "Formatting completed with warnings"
melos run analyze || print_status "WARNING" "Analysis completed with warnings"
echo

echo "========================================"
echo "Setup Summary"
echo "========================================"
if [ $ERROR_COUNT -gt 0 ]; then
    print_status "WARNING" "Setup completed with $ERROR_COUNT warnings"
else
    print_status "SUCCESS" "Setup completed successfully"
fi
echo

echo "Available commands:"
echo "- melos run generate        : Generate code once"
echo "- melos run generate:watch  : Watch and generate code"
echo "- melos run format         : Format code"
echo "- melos run analyze        : Analyze code"
echo "- melos run test           : Run tests"
echo "- melos run build:apps     : Build all applications"
echo

echo "Next steps:"
echo "1. Update the API URLs in:"
echo "   packages/zugantor_core/lib/src/config/environment.dart"
echo "2. Run 'melos run build:apps' to build all applications"
echo "3. Review README.md for more information"
echo

[ $ERROR_COUNT -gt 0 ] && exit 1 || exit 0