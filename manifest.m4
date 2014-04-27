{
	"manifest_version": 2,
	"name": "antislacker",
	"description": "TODO: add a description",
	"version": "syscmd(`json < package.json version | tr -d \\n')",
	"icons": {
		"128": "icons/128.png"
	},

	"page_action": {
		"default_icon": {
			"19": "icons/19.png"
		}
	},

	"background": {
		"scripts": ["lib/background.js"]
	},
	"web_accessible_resources": [
		"lib/message.html"
	],
	"options_page": "lib/options.html",

	"permissions": [
    	"tabs",
		"<all_urls>"
	]
}
