import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

/**
 * Trigger tự động tạo User Document trong Firestore khi có tài khoản mới đăng ký
 */
export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userId = user.uid;
  const email = user.email || "";
  const displayName = user.displayName || email.split("@")[0] || "User";

  const userRef = db.collection("users").doc(userId);

  try {
    await userRef.set({
      id: userId,
      email: email,
      display_name: displayName,
      role: "OWNER", // Mặc định người đăng ký đầu tiên có quyền tạo/quản lý nhóm
      family_id: null,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    functions.logger.info(`User document created successfully for ${userId}`);
  } catch (error) {
    functions.logger.error(`Error creating user document for ${userId}:`, error);
  }
});

/**
 * Trigger dọn dẹp các tài nguyên thuộc về nhóm gia đình khi nhóm bị xóa
 */
export const onFamilyGroupDeleted = functions.firestore
  .document("families/{familyId}")
  .onDelete(async (snap, context) => {
    const familyId = context.params.familyId;
    const batch = db.batch();

    functions.logger.info(`Cleaning up data for family group: ${familyId}`);

    const subCollections = ["pantry_items", "budgets", "meal_plans", "shopping_lists"];

    for (const col of subCollections) {
      const docs = await db.collection("families").doc(familyId).collection(col).get();
      docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
    }

    try {
      await batch.commit();
      functions.logger.info(`Successfully deleted all sub-collections for family: ${familyId}`);
    } catch (error) {
      functions.logger.error(`Error deleting sub-collections for family ${familyId}:`, error);
    }
  });
