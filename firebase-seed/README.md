# Firebase Firestore Seed Project

🚀 **Ready-to-use Firebase data seeding project for MS Computer Sangola**

## 📋 Quick Setup

### Step 1: Download Service Account Key
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → **Project Settings** → **Service Accounts**
3. Click **"Generate New Private Key"**
4. Download `serviceAccountKey.json` file

### Step 2: Place Service Account Key
- Copy `serviceAccountKey.json` to this project folder
- ⚠️ **Never commit this file to Git** (add to .gitignore)

### Step 3: Update Image URLs
**Edit JSON files** and replace placeholder URLs with your actual Firebase Storage URLs:

**In `products.json`:**
```json
"imageUrl": "https://firebasestorage.googleapis.com/v0/b/YOUR-PROJECT-ID.appspot.com/o/products%2Fyour-image.jpg?alt=media"
```

**In `banners.json` and `contact.json`:**
```json
// Add banner images if needed
"imageUrl": "https://firebasestorage.googleapis.com/v0/b/YOUR-PROJECT-ID.appspot.com/o/banners%2Fbanner.jpg?alt=media"
```

### Step 4: Install Dependencies & Run
```bash
npm install
node seed.js
```

## 📁 Project Structure

```
firebase-seed/
├── package.json          # NPM dependencies
├── seed.js              # Main seeding script
├── products.json        # Product data (6 sample products)
├── banners.json         # Banner data (homepage banner)
├── contact.json         # Contact information
└── serviceAccountKey.json  # ⚠️ ADD THIS FILE (don't commit to Git)
```

## 🎯 Firebase Collections Created

### 1. **products** Collection
- 6 sample products with Marathi names
- Categories: लॅपटॉप, प्रिंटर, सीसीटीव्ही, etc.
- Fields: name_marathi, price, category, description_marathi, inStock, imageUrl

### 2. **banners** Collection
- Homepage banner document
- Marathi title and subtitle
- Active status flag

### 3. **contact** Collection
- Business contact information
- Phone numbers, address, social media links

## 🔧 Customization

### Add More Products
Edit `products.json` and add new product objects:
```json
{
  "id": "product7",
  "name_marathi": "तुझा नवीन प्रॉडक्ट",
  "price": 15000,
  "category": "तुझी कॅटेगरी",
  "description_marathi": "प्रॉडक्ट डिस्क्रिप्शन",
  "inStock": true,
  "imageUrl": "तुझ्या इमेजचा Firebase Storage URL"
}
```

### Update Contact Info
Edit `contact.json` with your actual information.

## 🚨 Important Notes

1. **Service Account Key Security**
   - Add `serviceAccountKey.json` to `.gitignore`
   - Never commit this file to version control

2. **Image URLs**
   - Replace placeholder URLs with actual Firebase Storage URLs
   - Upload images to Firebase Storage first
   - Use proper URL encoding for spaces in filenames

3. **Firebase Rules**
   Ensure your Firestore security rules allow read/write access for your app.

## 🎉 Success Output
```
✅ Imported: products/product1
✅ Imported: products/product2
✅ Imported: banners/homepage
✅ Imported: contact/info
🎉 All data imported successfully!
```

## 🆘 Troubleshooting

**Error: "Cannot find module 'firebase-admin'"**
```bash
npm install
```

**Error: "Permission denied"**
- Check Firebase security rules
- Ensure service account key is valid

**Error: "Invalid credentials"**
- Verify serviceAccountKey.json is correct
- Check Firebase project ID matches

## 📞 Support
Ready-to-use project for MS Computer Sangola Firebase integration! 🎯
