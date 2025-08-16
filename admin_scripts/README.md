# Admin User Registration

This script allows you to register admin users directly without email verification.

## GitHub Actions Pipeline Setup

1. **Add Service Account Secret**:
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `SERVICE_ACCOUNT_JSON`
   - Value: Paste the entire content of your Firebase service account JSON file
   - Click "Add secret"

2. **Run the Workflow**:
   - Go to your GitHub repository → Actions
   - Select "Admin Registration" workflow
   - Click "Run workflow"
   - Provide inputs:
     - `email`: Admin email address
     - `password`: Admin password
   - Click "Run workflow"

3. **Verify Execution**:
   - The workflow will:
     1. Checkout your code
     2. Setup Node.js
     3. Install dependencies
     4. Register the admin user

## Local Usage

```bash
node register_admin.js --email <admin_email> --password <password> --service-account <path_to_service_account_json>
```

Example:
```bash
node register_admin.js --email Tendanisadikiadmin@gmail.com --password securepassword123 --service-account ./service-account.json
```

## Security Notes
- Keep service account credentials secure
- Never commit service account JSON files to version control
- Add service account files to .gitignore:
  ```gitignore
  *.json
  ```
