import Feedback from "../models/feedbackModel.js";
import Notification from "../models/notificationModel.js";
import User from "../models/userModel.js";

export const getFeedback = async (req, res) => {
    try {
        const feedback = await Feedback.findById(req.params.id);
        res.status(201).json(feedback);
    } catch (error) {
        console.log("Error in getting feedback ", error.message);
        res.status(500).json({ success: false, message: "Server error" });
    }
}

export const createFeedback = async (req, res) => {
    const feedback = req.body;

    let emptyFields = [];

    if (!feedback.name) {
        emptyFields.push('name');
    }
    
    if (!feedback.email) {
        emptyFields.push('email');
    }

    if (!feedback.message) {
        emptyFields.push('message');
    } 

    if (emptyFields.length > 0) {
        return res.status(404).json({error: "Please fill in all the fields", emptyFields});
    }

    //check format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailRegex.test(feedback.email)) {
        return res.status(400).json({ error: "Invalid email format"});
    }

    const newFeedback = new Feedback({
        userId: req.user._id,
        name: feedback.name,
        email: feedback.email,
        category: feedback.category,
        message: feedback.message
    });

    const admins = await User.find({role: "admin"});

    try {
        await newFeedback.save();

        const notifications = admins.map((admin) => ({
            from: req.user._id,
            to: admin._id,
            feedbackId: newFeedback._id,
            type: "New Feedback"
        }))

        await Notification.insertMany(notifications);

        res.status(201).json({ success : true, data : newFeedback});
    } catch (error) {
        console.log("Error in create feedback ", error.message);
        res.status(500).json({success: false, message: "Server error"});
    }
}

export const getAllFeedbacks = async (req, res) => {
    try {
        const feedbacks = await Feedback.find();
        res.status(201).json(feedbacks);
    } catch (error) {
        console.log("Error in getting all feedbacks ", error.message);
        res.status(500).json({ success: false, message: "Server error" });
    }
}

export const getAllUserFeedbacks = async (req, res) => {
    try {
        const userFeedbacks = await Feedback.find({userId: req.user._id});
        res.status(201).json(userFeedbacks);
    } catch (error) {
        console.log("Error in getting all user feedbacks ", error.message);
        res.status(500).json({ success: false, message: "Server error" });
    }
}

export const updateFeedbackStatusStart = async (req, res) => {
    const {feedbackId} = req.body;
    try {
        const feedback = await Feedback.findById(feedbackId);
        if (!feedback) {
            return res.status(404).json({error: "Feedback not available"});
        } 

        if (feedback.status === "In Progress") {
            return res.status(403).json({error: "Feedback is already in progress to be resolved"});
        }
        
        if (feedback.status === "Waiting to resolve") {
            feedback.status = "In Progress";
            feedback.startResolve = new Date();
        } 

        await feedback.save();
        res.status(200).json(feedback);
    } catch (error) {
        console.log("Error in update feedback status: ", error.message)
        res.status(500).json({error: error.message});
    }
}

export const updateFeedbackStatusFinish = async (req, res) => {

    const {feedbackId, userId, comment: feedbackComment, images: feedbackImages} = req.body;

    console.log(feedbackImages);

    try {
        const feedback = await Feedback.findById(feedbackId);
        if (!feedback) {
            res.status(404).json({error: "Feedback not available"});
        } 

        if (feedback.status === "In Progress") {
            feedback.status = "Resolved";
            feedback.finishResolve = new Date();

            feedback.updateComment = feedbackComment;
            feedback.updateImages = [
                ...feedback.updateImages,
                ...feedbackImages
            ];

            const newNotification = new Notification({
                from: userId,
                to: feedback.userId,
                feedbackId: feedbackId,
                type: "Feedback Resolved"
            }) 

            await newNotification.save();

            const allAdmins = await User.find({ role: "admin" });
            for (const admin of allAdmins) {
                if (admin._id.toString() !== userId) {
                await new Notification({
                    from: userId,
                    to: admin._id,
                    feedbackId,
                    type: "Feedback Resolved"
                }).save();
                }
            }
        }
        
        if (feedback.status === "Waiting to resolve") {
            return res.status(403).json({error: "Feedback is already in progress to be resolved"});
        } 

        await feedback.save();
        res.status(200).json(feedback);
    } catch (error) {
        console.log("Error in update feedback status: ", error.message)
        res.status(500).json({error: error.message});
    }
}

export const updateFeedbackRating = async (req, res) => {
    try {
        const {feedbackId, rating: newRating} = req.body;
        const feedback = await Feedback.findById(feedbackId);

        if (!feedback) {
            res.status(404).json({error: "Feedback not available"});
        } 

        console.log('rate feedback');

        if (feedback.status === "Resolved") {
            feedback.userRating = newRating;
            await feedback.save();
            return res.status(200).json(feedback);
        }
        
        res.status(400).json({message: "Feedback not resolved yet"});
    } catch (error) {
        console.log("Error in update feedback rating: ", error.message)
        res.status(500).json({error: error.message});
    }
}

export const getStats = async (req, res) => {
    const now = new Date();
    const twentyEightDaysAgo = new Date(now.getTime() - 28 * 24 * 60 * 60 * 1000);

    // const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    // const startOfNextMonth = new Date(now.getFullYear(), now.getMonth() + 1, 1);

    try {
        const totalFeedbackForLast28Days = await Feedback.countDocuments({
            createdAt: {
                $gte: twentyEightDaysAgo,
                $lte: now
            }
        });

        const newUnresolvedCountForLast28Days = await Feedback.countDocuments({
            status: "Waiting to resolve",
            createdAt: {
                $gte: twentyEightDaysAgo,
                $lte: now
            }
        });

        const InProgressCountForLast28Days = await Feedback.countDocuments({
            status: "In Progress",
            startResolve: {
                $gte: twentyEightDaysAgo,
                $lte: now
            },
        });

        const totalResolvedForLast28Days = await Feedback.countDocuments({
            finishResolve: {
                $gte: twentyEightDaysAgo,
                $lte: now
            }
        });

        const ratingResult = await Feedback.aggregate([
            {
                $match: {
                    userRating: { $ne: null },
                    createdAt: {
                        $gte: twentyEightDaysAgo,
                        $lte: now
                    } // Exclude nulls
                }
            },
            {
                $group: {
                    _id: null,
                    averageValue: { $avg: "$userRating" }
                }
            }
        ]);
        const averageRating = ratingResult[0]?.averageValue || 0;

        let averageResolveTime = await Feedback.aggregate([
            {
            $match: {
                startResolve: { $exists: true, $ne: null },
                finishResolve: { $exists: true, $ne: null },
                finishResolve: { $gte: twentyEightDaysAgo, $lte: now }
            }
            },
            {
            $project: {
                diffInMillis: { $subtract: ["$finishResolve", "$startResolve"] }
            }
            },
            {
            $group: {
                _id: null,
                avgDifferenceMillis: { $avg: "$diffInMillis" }
            }
            },
            {
            $project: {
                _id: 0,
                avgDifferenceInDays: { $divide: ["$avgDifferenceMillis", 1000 * 60 * 60 * 24] }
            }
            }
        ]);

        averageResolveTime = averageResolveTime[0]?.avgDifferenceInDays || 0;

        // Optionally fix to 2 decimal places
        averageResolveTime = Number(averageResolveTime.toFixed(2));

        res.json({
            totalFeedbackForLast28Days,
            newUnresolvedCountForLast28Days,
            InProgressCountForLast28Days,
            totalResolvedForLast28Days,
            averageResolveTime: Number(averageResolveTime.toFixed(1)),
            averageRating: Number(averageRating.toFixed(1)),
        });
        
    } catch (error) {
        console.log("Error in get Stats controller: ", error.message);
        res.status(500).json({error: error.message});
    }
} 

export const getLineChartStats = async (req, res) => {
    const now = new Date();
    const twelveMonthsAgo = new Date(now.getFullYear(), now.getMonth() - 11, 1); 
    try {
        const rawData = await Feedback.aggregate([
            {
                $match: {
                createdAt: { $gte: twelveMonthsAgo },
                },
            },
            {
                $group: {
                _id: {
                    year: { $year: "$createdAt" },
                    month: { $month: "$createdAt" },
                },
                count: { $sum: 1 },
                },
            },
            {
                $sort: { "_id.year": 1, "_id.month": 1 },
            },
        ]);

        const resolvedData = await Feedback.aggregate([
        {
            $match: {
            finishResolve: { $ne: null, $gte: twelveMonthsAgo },
            },
        },
        {
            $group: {
            _id: {
                year: { $year: "$finishResolve" },
                month: { $month: "$finishResolve" },
            },
            count: { $sum: 1 },
            },
        },
        {
            $sort: { "_id.year": 1, "_id.month": 1 },
        },
        ]);

    const feedbackChartData = [];
    const resolvedFeedbackChartData = [];
    for (let i = 11; i >= 0; i--) {
      const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
      const year = date.getFullYear();
      const month = date.getMonth() + 1;

      const found = rawData.find(d => d._id.year === year && d._id.month === month);
      const resolved = resolvedData.find(d => d._id.year === year && d._id.month === month);
      feedbackChartData.push({
        year,
        month,
        count: found ? found.count : 0
      });

      resolvedFeedbackChartData.push({
        year,
        month,
        count: resolved ? resolved.count : 0
      });
    }

    res.json([feedbackChartData, resolvedFeedbackChartData]);
        
    } catch (error) {
        console.log("Error in getLineChartStatsController: ", error.message);
        res.status(500).json({error: error.message});
    }
}