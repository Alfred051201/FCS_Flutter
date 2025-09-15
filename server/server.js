import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import { connectDB } from "./db/connectDB.js";
import bodyParser from "body-parser";
import feedbackRoutes from "./routes/feedbackRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import analyticsRoutes from "./routes/analyticsRoutes.js";
import notificationRoutes from "./routes/notificationRoutes.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT;

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));
app.use(express.json());
app.use(cookieParser());
app.use("/api/analytics", analyticsRoutes);
app.use("/api/feedback", feedbackRoutes);
app.use("/api/notification", notificationRoutes);
app.use("/api/auth", authRoutes);

app.listen(PORT, () => {
    console.log("listening to port ", PORT);
    connectDB();
})