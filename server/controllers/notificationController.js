import Notification from "../models/notificationModel.js";

export const getNotifications = async (req, res) => {
    try {
        const { userId } = req.params;
        const notifications = await Notification.find({ to : userId }).sort({ createdAt: -1 })
        .populate({
			path: "feedbackId",
			select: "name createdAt status",
		});

        await Notification.updateMany({ to: userId }, { read: true });

        res.json(notifications);
    } catch (error) {
        console.log("Error in getNotifications function", error.message)
        res.status(500).json({error: "Internal Server Error"});
    }
}

export const deleteNotifications = async (req, res) => {
    try {
        const userId = req.user._id; 
        await Notification.deleteMany({to : userId});

        res.json({ message: "Notifications deleted successfully" })
    } catch (error) {
        console.log("Error in deleteNotifications function", error.message);
		res.status(500).json({ error: "Internal Server Error" });
    }
}

export const deleteOneNotification = async (req, res) => {
    try {
        const {notificationId} = req.body; 
        await Notification.findByIdAndDelete(notificationId);

        res.json({ message: "Notifications deleted successfully" })
    } catch (error) {
        console.log("Error in deleteOneNotification function", error.message);
		res.status(500).json({ error: "Internal Server Error" });
    }
}
