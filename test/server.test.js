const test = require("node:test")
const assert = require("node:assert")
const { createServer } = require("../src/server")

test("GET /api/health answers 200 with ok", async () => {
	const server = createServer().listen(0)
	await new Promise((resolve) => server.once("listening", resolve))
	try {
		const response = await fetch(`http://127.0.0.1:${server.address().port}/api/health`)
		assert.strictEqual(response.status, 200)
		assert.deepStrictEqual(await response.json(), { ok: true })
	} finally {
		server.close()
	}
})
