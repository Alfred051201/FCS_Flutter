import Feedback from "../models/feedbackModel.js"

export const getMonthlyChartData = async (req, res) => {
    try {
        const now = new Date();
		const startDate = new Date(now.getFullYear(), now.getMonth() - 11, 1); // 12 months including current month
		const endDate = new Date(now.getFullYear(), now.getMonth() + 1, 1); // exclusive upper bound

		const rawData = await Feedback.aggregate([
			{
				$match: {
					createdAt: {
						$gte: startDate,
						$lt: endDate
					}
				}
			},
			{
				$group: {
					_id: {
						month: { $dateToString: { format: "%Y-%m", date: "$createdAt", timezone: "Asia/Manila" } },
						status: "$status"
					},
					count: { $sum: 1 }
				}
			},
			{
				$project: {
					_id: 0,
					month: "$_id.month",
					status: "$_id.status",
					count: 1
				}
			}
		]);

		const statusList = ["Waiting to resolve", "In Progress", "Resolved"];
		const monthList = getLastNMonths(12, endDate);
		const monthlyFeedbackData = fillMonthlyStatusCounts(rawData, statusList, monthList);
        res.json(monthlyFeedbackData);
    } catch (error) {
        console.log("error in get chart data controller: ", error.message);
        res.status(500).json({message: "Server error", error: error.message})
    }
}

export const getDailyChartData = async (req, res) => {
    try {
        const rawData = await Feedback.aggregate([
			{
				$match: {
					createdAt: {
						$gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
						$lte: new Date()
					}
				}
			},
			{
				$group: {
					_id: {
						day: { $dateToString: { format: "%Y-%m-%d", date: "$createdAt", timezone: "Asia/Manila" } },
						status: "$status"
					},
					count: { $sum: 1 }
				}
			},
			{
				$project: {
					_id: 0,
					date: "$_id.day",
					status: "$_id.status",
					count: 1
				}
			}
		]);
        const dailyFeedbackData = fillMissingStatusCounts(rawData, ["Waiting to resolve", "In Progress", "Resolved"]);
        res.json(dailyFeedbackData);
    } catch (error) {
        console.log("error in get chart data controller: ", error.message);
        res.status(500).json({message: "Server error", error: error.message})
    }
}


function getLastNMonths(n, endDate) {
	const months = [];
	const baseDate = new Date(endDate);

	for (let i = n - 1; i >= 0; i--) {
		const date = new Date(baseDate.getFullYear(), baseDate.getMonth() - i, 1);
		const monthStr = date.toISOString().slice(0, 7); // e.g., "2025-05"
		months.push(monthStr);
	}
	return months;
}

function getLastNDates(n) {
	const dates = [];
	const today = new Date();
	today.setHours(0, 0, 0, 0); // Set to local midnight

	for (let i = n - 1; i >= 0; i--) {
		const d = new Date(today);
		d.setDate(today.getDate() - i);
		// Use local date in ISO format (YYYY-MM-DD)
		dates.push(d.toLocaleDateString("en-CA")); 
	}
	return dates;
}

function fillMissingStatusCounts(rawData, statusList) {
	const allDates = getLastNDates(7);
	const dateMap = new Map();

	// Group raw data by date
	for (const { date, status, count } of rawData) {
		if (!dateMap.has(date)) {
			dateMap.set(date, {});
		}
		dateMap.get(date)[status] = count;
	}

	// Fill in missing status counts with 0
	return allDates.map(date => {
		const statusCounts = dateMap.get(date) || {};
		const entry = { date };
		for (const status of statusList) {
			entry[status] = statusCounts[status] || 0;
		}
		return entry;
	});
}

function fillMonthlyStatusCounts(rawData, statusList, monthList) {
	const monthMap = new Map();

	for (const { month, status, count } of rawData) {
		if (!monthMap.has(month)) {
			monthMap.set(month, {});
		}
		monthMap.get(month)[status] = count;
	}

	// Ensure each month has all statuses
	return monthList.map(month => {
		const counts = monthMap.get(month) || {};
		const result = { month };
		for (const status of statusList) {
			result[status] = counts[status] || 0;
		}
		return result;
	});
}