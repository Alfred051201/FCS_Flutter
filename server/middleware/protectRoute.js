import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/userModel.js";

dotenv.config();

export const protectRoute = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');

        if (!token) {
            return res.status(401).json({ message: "Unauthorized - No accessToken provided" });
        }

        //check if it is the correct token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        if (!decoded) {
            return res.status(401).json({ message: "Unauthorized - Invalid access token"})
        }

        const user = await User.findById(decoded.userId).select("-password");

		if (!user) {
			return res.status(404).json({ error: "User not found" });
		}

		req.user = user;
        req.token = token;
		next();
    } catch (error) {
        console.log("Error in protectRoute middleware", error.message);
        return res.status(401).json({ message: "Unauthorized - Invalid access token"});
    }
}