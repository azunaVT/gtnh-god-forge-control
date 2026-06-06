local sides = require("sides")

local loggerLib = require("lib.logger-lib")
local discordLoggerHandler = require("lib.logger-handler.discord-logger-handler-lib")
local fileLoggerHandler = require("lib.logger-handler.file-logger-handler-lib")
local scrollListLoggerHandler = require("lib.logger-handler.scroll-list-logger-handler-lib")

local heliofusionExoticizerController = require("src.heliofusion-exoticizer-controller")

local config = {
  enableAutoUpdate = true, -- Enable auto update on start

  logger = loggerLib:newFormConfig({
    name = "God Forge Control",
    timeZone = 3, -- Your time zone
    handlers = {
      discordLoggerHandler:newFormConfig({
        logLevel = "warning",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        discordWebhookUrl = "" -- Discord Webhook URL
      }),
      fileLoggerHandler:newFormConfig({
        logLevel = "info",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        filePath = "logs.log"
      }),
      scrollListLoggerHandler:newFormConfig({
        logLevel = "debug",
        logsListSize = 32
      }),
    }
  }),


  controller = heliofusionExoticizerController:newFormConfig({
    magmatterMode = false, -- Enable mode of production magmatter.
    outputMeDriveSide = sides.east, -- Side of the transposer which connected to output AE network.
    mainIoPortSide = sides.west -- Side of the transposer which connected to main AE network.
  })
}

return config