const http = require("node:http")

/** The app's server: GET /api/health answers 200 with {"ok":true}. */
function createServer() {
	return http.createServer((request, response) => {
		if (request.method === "GET" && request.url === "/api/health") {
			response.writeHead(200, { "content-type": "application/json" })
			return response.end(JSON.stringify({ ok: true }))
		}
		response.writeHead(404)
		response.end()
	})
}

if (require.main === module) {
	const port = Number(process.env.PORT) || 3000
	createServer().listen(port, () => console.log(`Leave Tracker on port ${port}`))
}

module.exports = { createServer }
