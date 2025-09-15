import express from "express";
import { protectRoute } from "../middleware/protectRoute.js";
import { deleteNotifications, deleteOneNotification, getNotifications } from "../controllers/notificationController.js";

const router = express.Router();

router.get("/:userId", protectRoute, getNotifications);
router.delete("/:userId", protectRoute, deleteNotifications);
router.delete("/single", protectRoute, deleteOneNotification);

export default router;