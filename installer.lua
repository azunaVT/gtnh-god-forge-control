local shell = require("shell")
local term = require("term")
local filesystem = require("filesystem")
local internet = require("internet")

---@class ProgramDescription
---@field name string
---@field description string
---@field url string

local repositoryUrl = "https://github.com/azunaVT/gtnh-god-forge-control/tarball/main"
local tarManUrl = "https://raw.githubusercontent.com/mpmxyz/ocprograms/master/usr/man/tar.man"
local tarBinUrl = "https://raw.githubusercontent.com/mpmxyz/ocprograms/master/home/bin/tar.lua"

---Check if Open OS installed
local function isOsInstalled()
  local file = io.open("/home/test.txt", "w")

  if file == nil then
    error("Open OS is not installed")
  end

  file:close()

  shell.execute("rm /home/test.txt")
end

---Check connection to github
local function isGitHubAvailable()
  local success, result = pcall(internet.request, "https://github.com")

	if not success then
		if result then
			if result():match("PKIX") then
				error("Download server SSL certificates was rejected by Java. Update your Java version or install certificates for github.com manually")
			else
				error("Download server is unavailable: "..tostring(result))
			end
		else
			error("Download server is unavailable for unknown reasons")
		end
	end
end

---Download and install tar utility
local function downloadTarUtility()
  if filesystem.exists("/bin/tar.lua") then
    return
  end

  shell.setWorkingDirectory("/usr/man")
  shell.execute("wget -fq "..tarManUrl)
  shell.setWorkingDirectory("/bin")
  shell.execute("wget -fq "..tarBinUrl)
end

---Download and install the God Forge Control script
---@param url string
local function downloadProgram(url)
  term.write("Installing GTNH God Forge Control script...\n")

  shell.execute("wget -fq "..url.." program.tar")
  shell.execute("tar -xf program.tar")
  shell.execute("rm program.tar")

  term.write("Installation complete\n")
end

---Make auto run
local function makeAutoRun()
  term.write("\nCreate auto run [y/n]\n")
  term.write("===>")

  local userInput = io.read()

  if string.lower(userInput) == "y" then
    local file = assert(io.open("/home/.shrc", "w"))
    file:write("main")
    file:close()

    term.write("Auto run created\n")
  else
    term.write("Auto run ignored\n")
  end
end

---Main
local function main()
  isOsInstalled()
  isGitHubAvailable()

  downloadTarUtility()

  shell.setWorkingDirectory("/home")

  makeAutoRun()
  downloadProgram(repositoryUrl)
end

main()