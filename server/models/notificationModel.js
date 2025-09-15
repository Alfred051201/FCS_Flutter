import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
    {
        from: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },

        to: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },

        feedbackId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Feedback",
            required: true,
        },

        type: {
			type: String,
			required: true,
			enum: ["New Feedback", "Feedback Resolved"],
		},

        read: {
            type: Boolean,
            default: false,
        },
    },
    {timestamps: true}
)

const Notification = mongoose.model("Notification", notificationSchema);

export default Notification;