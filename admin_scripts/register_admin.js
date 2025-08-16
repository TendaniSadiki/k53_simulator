const admin = require('firebase-admin');
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');

async function registerAdmin(email, password, serviceAccountPath) {
  try {
    // Initialize Firebase Admin SDK
    const serviceAccount = require(serviceAccountPath);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });

    // Create user with email verification bypassed
    const user = await admin.auth().createUser({
      email,
      password,
      emailVerified: true
    });

    // Set admin custom claim
    await admin.auth().setCustomUserClaims(user.uid, { admin: true });

    console.log(`✅ Successfully created admin user: ${email}`);
    console.log(`UID: ${user.uid}`);
  } catch (error) {
    console.error('❌ Error creating admin user:', error);
    process.exit(1);
  }
}

// Parse command line arguments
const argv = yargs(hideBin(process.argv))
  .option('email', {
    alias: 'e',
    describe: 'Admin email address',
    demandOption: true,
    type: 'string'
  })
  .option('password', {
    alias: 'p',
    describe: 'Admin password',
    demandOption: true,
    type: 'string'
  })
  .option('service-account', {
    alias: 's',
    describe: 'Path to Firebase service account JSON file',
    demandOption: true,
    type: 'string'
  })
  .help()
  .alias('help', 'h')
  .parse();

// Execute the function
registerAdmin(argv.email, argv.password, argv.serviceAccount);