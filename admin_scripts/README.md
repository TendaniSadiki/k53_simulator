# Admin User Registration Script (Local Execution)

This script allows you to register admin users directly without email verification. Since GitHub Actions requires billing setup, use these instructions to run the script locally.

## Prerequisites
1. Install Node.js (version 18 or higher)
2. Download your Firebase service account key (already provided as `k53-simulator-4766f5f6fe07.json`)

## Setup Instructions
1. Navigate to the `admin_scripts` directory:
```bash
cd admin_scripts
```

2. Install required packages:
```bash
npm install firebase-admin yargs
```

3. Return to the project root:
```bash
cd ..
```

## Usage
Run the script with your admin credentials (make sure you're in the project root directory):
```bash
node admin_scripts/register_admin.js --email "Tendanisadikiadmin@gmail.com" --password "your_secure_password" --service-account ./k53-simulator-4766f5f6fe07.json
```

### Options
- `--email`: Admin email address (required)
- `--password`: Admin password (minimum 6 characters, required)
- `--service-account`: Path to your Firebase service account JSON file (e.g., `./k53-simulator-4766f5f6fe07.json`). This file can be downloaded from Firebase Console > Project Settings > Service Accounts.

## Security Notes
- Keep the service account JSON file secure
- Never commit service account files to version control
- The .gitignore file already excludes *.json files except firebase.json
- Rotate service account keys periodically through Firebase Console
- Delete the service account file after use for maximum security
