import mongoose from "mongoose";

const feedbackSchema = mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    name: {
        type: String,
        required: true
    }, 
    email: {
        type: String,
        required: true
    },
    category: {
        type: String,
        required: true,
        enum: ['Bug Report', 'Feature Request', 'General Inquiry']
    },
    message: {
        type: String,
        required: true
    },
    status: {
        type: String,
        enum: ['Waiting to resolve', 'In Progress', 'Resolved'],
        default: 'Waiting to resolve',
    },
    startResolve: {
        type: Date,
        default: null
    },
    finishResolve: {
        type: Date,
        default: null
    },
    userRating: {
        type: Number,
        default: null
    },
    updateComment: {
        type: String,
        default: null
    },
    updateImages: {
        type: [String],
        default: []
    }
}, {timestamps: true});

const Feedback = mongoose.model("Feedback", feedbackSchema);

export default Feedback;