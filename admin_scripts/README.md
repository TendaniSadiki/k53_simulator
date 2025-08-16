# Admin User Registration Script

This script allows you to register admin users directly without email verification.

## Setup Instructions

1. Install required packages:
```bash
npm install firebase-admin yargs
```

2. Download your Firebase service account key:
- Go to Firebase Console > Project Settings > Service Accounts
- Click "Generate new private key" and save the JSON file

## Usage

```bash
node register_admin.js --email <admin_email> --password <password> --service-account <path_to_service_account_json>
```

Example:
```bash
node register_admin.js --email Tendanisadikiadmin@gmail.com --password securepassword123 --service-account ./service-account.json
```

## Note on Dart Version
A Dart version of this script was previously available but has been removed due to compatibility issues with Firebase Admin SDK in Flutter projects.

## Security Notes
- Keep service account credentials secure
- Never commit service account JSON files to version control
- Add service account files to .gitignore:
  ```gitignore
  *.json
  ```
