import express from "express";
import { getMonthlyChartData, getDailyChartData } from "../controllers/analyticsController.js";
import { protectRoute } from "../middleware/protectRoute.js";
import { adminRoute } from "../middleware/adminRoute.js";

const router = express.Router();

router.get("/month", protectRoute, adminRoute, getMonthlyChartData);
router.get("/day", protectRoute, adminRoute, getDailyChartData);

export default router;