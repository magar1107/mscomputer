const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function importFile(collectionName, fileName) {
  const filePath = path.join(__dirname, fileName);
  const docs = JSON.parse(fs.readFileSync(filePath, "utf8"));

  for (const doc of docs) {
    const docId = doc.id || db.collection(collectionName).doc().id;
    const data = { ...doc };
    delete data.id;
    await db.collection(collectionName).doc(docId).set(data);
    console.log(`✅ Imported: ${collectionName}/${docId}` );
  }
}

(async () => {
  try {
    await importFile("products", "products.json");
    await importFile("banners", "banners.json");
    await importFile("contact", "contact.json");
    console.log("🎉 All data imported successfully!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
})();
