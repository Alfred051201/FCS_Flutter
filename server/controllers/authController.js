import { generateTokenAndSetCookie } from "../lib/utils/generateToken.js";
import User from "../models/userModel.js";
import bcrypt from "bcryptjs";

export const signup = async (req, res) => {
    
    const {username, email, password} = req.body;
    try {
        const userExists = await User.findOne({ username });

        if (userExists) {
            return res.status(400).json({message: "User already exists"});
        } 

        const emailExists = await User.findOne({ email });

        if (emailExists) {
            return res.status(400).json({message: "Email already exists"});
        } 
        

        const user = await User.create({username, email, password});

        res.status(201).json({
            user: {
                _id: user._id,
                username: user.username,
                email: user.email,
                role: user.role,
            },
            message: "User created successfully",
        })
    } catch (error) {
        console.log("Error in signup controller", error.message);
        res.status(500).json({ message: error.message });
    }
}

export const login = async (req, res) => {
    try {
        const {username, email, password} = req.body;
        const user = await User.findOne({username});
        const isPasswordValid = await bcrypt.compare(password, user?.password || "");

        if (!user || !isPasswordValid) {
            return res.status(400).json({message: "Invalid username or password"});
        }
         

        const token = generateTokenAndSetCookie(user._id, res);

        res.status(200).json({ token, ...user._doc });
    } catch ( error ) {
        console.log("Error in login controller", error.message);
        res.status(500).json({error: "Internal Server Error"});
    }
}

export const logout = async (req, res) => {
    try {
        res.cookie("jwt", "", {maxAge:0})
        res.status(200).json({message:"Logged out successfully"})
    } catch (error) {
        console.log("Error in logout controller", error.message);
        res.status(500).json({error: "Internal Server Error"});
    }
}

export const getProfile = async (req, res) => {
    try {
		res.json(req.user);
	} catch (error) {
		res.status(500).json({ message: "Server error", error: error.message });
	}
}
