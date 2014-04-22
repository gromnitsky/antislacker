{
	"manifest_version": 2,
	"name": "antislacker",
	"description": "TODO: add a description",
	"version": "syscmd(`json < package.json version | tr -d \\n')",

	"background": {
		"scripts": ["lib/background.js"]
	},
	"web_accessible_resources": [
		"lib/message.html"
	],

	"permissions": [
    	"tabs",
		"<all_urls>"
	]
}
