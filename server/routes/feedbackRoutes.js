import express from "express";
import { createFeedback, getAllFeedbacks, getStats, updateFeedbackStatusStart, updateFeedbackStatusFinish, getAllUserFeedbacks, updateFeedbackRating, getFeedback, getLineChartStats } from "../controllers/feedbackController.js";
import { protectRoute } from "../middleware/protectRoute.js";
import { adminRoute } from "../middleware/adminRoute.js";

const router = express.Router();

router.post("/", protectRoute, createFeedback);
router.get("/", protectRoute, adminRoute, getAllFeedbacks);
router.get("/stats", protectRoute, adminRoute, getStats)
router.get("/stats/line", protectRoute, adminRoute, getLineChartStats)
router.get("/user", protectRoute, getAllUserFeedbacks);
router.put("/start", protectRoute, updateFeedbackStatusStart);
router.put("/finish", protectRoute, updateFeedbackStatusFinish);
router.put("/rating", protectRoute, updateFeedbackRating);
router.get("/:id", protectRoute, getFeedback);


export default router;