-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local tfd = require("plugin.tinyFileDialogs")
local widget = require("widget")
local json = require("json")
local isWindows = system.getInfo("platform") == "win32"
local userHomeDocumentsPath = isWindows and "%HOMEPATH%\\Documents\\" or "~/Documents"

local openFileDialog =
	widget.newButton(
	{
		label = "Open File Dialog",
		emboss = false,
		shape = "roundedRect",
		width = 180,
		height = 40,
		cornerRadius = 2,
		fillColor = {
			default = {0, 0, 0, 1},
			over = {1, 0.1, 0.7, 0.4}
		},
		strokeColor = {
			default = {1, 0.4, 1, 1},
			over = {0.8, 0.8, 1, 1}
		},
		labelColor = {
			default = {1, 1, 1},
			over = {0, 0, 0, 1}
		},
		strokeWidth = 2,
		onPress = function(event)
			local foundFiles =
				tfd.openFileDialog(
				{
					title = "Select Files (limited to 32 files)",
					initialPath = userHomeDocumentsPath,
					filters = {"*.txt", "*.rtf", "*.md", "*.doc", "*.docx"},
					singleFilterDescription = "Text File(s)| *.txt;*.rtf;*.md;*.doc;*.docx etc",
					multiSelect = true
				}
			)
			local foundFileType = type(foundFiles)

			if (foundFileType == "string") then
				print(foundFiles)
			elseif (foundFileType == "table") then
				print(json.prettify(foundFiles))
			end
		end
	}
)
openFileDialog.x = display.contentCenterX
openFileDialog.y = display.contentCenterY - 80

local openFolderDialog =
	widget.newButton(
	{
		label = "Open Folder Dialog",
		emboss = false,
		shape = "roundedRect",
		width = 180,
		height = 40,
		cornerRadius = 2,
		fillColor = {
			default = {0, 0, 0, 1},
			over = {1, 0.1, 0.7, 0.4}
		},
		strokeColor = {
			default = {1, 0.4, 1, 1},
			over = {0.8, 0.8, 1, 1}
		},
		labelColor = {
			default = {1, 1, 1},
			over = {0, 0, 0, 1}
		},
		strokeWidth = 2,
		onPress = function(event)
			local foundFolder =
				tfd.openFolderDialog(
				{
					title = "Select Folder",
					initialPath = userHomeDocumentsPath
				}
			)
			local foundFolderType = type(foundFiles)

			if (foundFolderType ~= nil) then
				print(foundFolder)
			end
		end
	}
)
openFolderDialog.x = openFileDialog.x
openFolderDialog.y = openFileDialog.y + openFileDialog.contentHeight + openFolderDialog.contentHeight * 0.5

local saveFileDialog =
	widget.newButton(
	{
		label = "Save File Dialog",
		emboss = false,
		shape = "roundedRect",
		width = 180,
		height = 40,
		cornerRadius = 2,
		fillColor = {
			default = {0, 0, 0, 1},
			over = {1, 0.1, 0.7, 0.4}
		},
		strokeColor = {
			default = {1, 0.4, 1, 1},
			over = {0.8, 0.8, 1, 1}
		},
		labelColor = {
			default = {1, 1, 1},
			over = {0, 0, 0, 1}
		},
		strokeWidth = 2,
		onPress = function(event)
			local savedFile =
				tfd.saveFileDialog(
				{
					title = "Select Files (limited to 32 files)",
					initialPath = userHomeDocumentsPath,
					filters = {"*.txt", "*.rtf", "*.md", "*.doc", "*.docx"},
					singleFilterDescription = "Text File(s)| *.txt;*.rtf;*.md;*.doc;*.docx etc"
				}
			)

			if (savedFile ~= nil) then
				print(savedFile)
			end
		end
	}
)
saveFileDialog.x = openFileDialog.x
saveFileDialog.y = openFolderDialog.y + openFolderDialog.contentHeight + saveFileDialog.contentHeight * 0.5
