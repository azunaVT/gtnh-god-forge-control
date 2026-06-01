local component = require("component")
local event = require("event")
local computer = require("computer")

local stateMachineLib = require("lib.state-machine-lib")
local componentDiscoverLib = require("lib.component-discover-lib")

---@class HeliofusionExoticizerControllerConfig
---@field magmatterMode boolean
---@field transposerAddress string
---@field outputMeInterfaceAddress string
---@field outputMeTransposerSide number
---@field mainMeInterfaceAddress string
---@field mainMeTransposerSide number
---@field plasmaFabricatorMeTransposerSide number

---@class OutputItem
---@field label string
---@field count number
---@field isLiquid boolean

---@type table<"Gluon"|"Magmatter", table<string, string>>
local plasmaList = {
  ["Gluon"] = {
    ["Aluminium"] = "plasma.aluminium",
    ["Americium"] = "plasma.americium",
    ["Antimony"] = "plasma.antimony",
    ["Ardite"] = "plasma.ardite",
    ["Argon"] = "plasma.argon",
    ["Arsenic"] = "plasma.arsenic",
    ["Barium"] = "plasma.barium",
    ["Beryllium"] = "plasma.beryllium",
    ["Cadmium"] = "plasma.cadmium",
    ["Caesium"] = "plasma.caesium",
    ["Calcium"] = "plasma.calcium",
    ["Carbon"] = "plasma.carbon",
    ["Cerium"] = "plasma.cerium",
    ["Chlorine"] = "plasma.chlorine",
    ["Cobalt"] = "plasma.cobalt",
    ["Copper"] = "plasma.copper",
    ["Curium"] = "plasma.curium",
    ["Desh"] = "plasma.desh",
    ["Deuterium"] = "plasma.deuterium",
    ["Dysprosium"] = "plasma.dysprosium",
    ["Erbium"] = "plasma.erbium",
    ["Europium"] = "plasma.europium",
    ["Fluorine"] = "plasma.fluorine",
    ["Gadolinium"] = "plasma.gadolinium",
    ["Gallium"] = "plasma.gallium",
    ["Germanium"] = "plasma.germanium",
    ["Gold"] = "plasma.gold",
    ["Hafnium"] = "plasma.hafnium",
    ["Helium"] = "plasma.helium",
    ["Holmium"] = "plasma.holmium",
    ["Hydrogen"] = "plasma.hydrogen",
    ["Indium"] = "plasma.indium",
    ["Iodine"] = "plasma.iodine",
    ["Iron"] = "plasma.iron",
    ["Lanthanum"] = "plasma.lanthanum",
    ["Lithium"] = "plasma.lithium",
    ["Lutetium"] = "plasma.lutetium",
    ["Magnesium"] = "plasma.magnesium",
    ["Manganese"] = "plasma.manganese",
    ["Mercury"] = "plasma.mercury",
    ["Meteoric Iron"] = "plasma.meteoriciron",
    ["Molybdenum"] = "plasma.molybdenum",
    ["Neodymium"] = "plasma.neodymium",
    ["Nickel"] = "plasma.nickel",
    ["Niobium"] = "plasma.niobium",
    ["Nitrogen"] = "plasma.nitrogen",
    ["Oriharukon"] = "plasma.oriharukon",
    ["Palladium"] = "plasma.palladium",
    ["Phosphorus"] = "plasma.phosphorus",
    ["Potassium"] = "plasma.potassium",
    ["Praseodymium"] = "plasma.praseodymium",
    ["Promethium"] = "plasma.promethium",
    ["Radon"] = "plasma.radon",
    ["Raw Silicon"] = "plasma.silicon",
    ["Rhenium"] = "plasma.rhenium",
    ["Rhodium"] = "plasma.rhodium",
    ["Rubidium"] = "plasma.rubidium",
    ["Ruthenium"] = "plasma.ruthenium",
    ["Samarium"] = "plasma.samarium",
    ["Silver"] = "plasma.silver",
    ["Sodium"] = "plasma.sodium",
    ["Strontium"] = "plasma.strontium",
    ["Sulfur"] = "plasma.sulfur",
    ["Tantalum"] = "plasma.tantalum",
    ["Tellurium"] = "plasma.tellurium",
    ["Terbium"] = "plasma.terbium",
    ["Thallium"] = "plasma.thallium",
    ["Thorium 232"] = "plasma.thorium232",
    ["Thulium"] = "plasma.thulium",
    ["Tin"] = "plasma.tin",
    ["Titanium"] = "plasma.titanium",
    ["Tritium"] = "plasma.tritium",
    ["Tungsten"] = "plasma.tungsten",
    ["Uranium 235"] = "plasma.uranium235",
    ["Uranium 238"] = "plasma.uranium",
    ["Vanadium"] = "plasma.vanadium",
    ["Ytterbium"] = "plasma.ytterbium",
    ["Yttrium"] = "plasma.yttrium",
    ["Zinc"] = "plasma.zinc",
    ["Zirconium"] = "plasma.zirconium"
  },
  ["Magmatter"] = {
    ["Awakened Draconium"] = "plasma.draconiumawakened",
    ["Bedrockium"] = "plasma.bedrockium",
    ["Celestial Tungsten"] = "plasma.celestialtungsten",
    ["Chromatic Glass"] = "plasma.chromaticglass",
    ["Cosmic Neutronium"] = "plasma.cosmicneutronium",
    ["Draconium"] = "plasma.draconium",
    ["Dragonblood"] = "plasma.dragonblood",
    ["Flerovium"] = "plasma.flerovium_gt5u",
    ["Hypogen"] = "plasma.hypogen",
    ["Ichorium"] = "plasma.ichorium",
    ["Infinity"] = "plasma.infinity",
    ["Neutronium"] = "plasma.neutronium",
    ["Rhugnor"] = "plasma.rhugnor",
    ["Six-Phased Copper"] = "plasma.sixphasedcopper",
    ["Tritanium"] = "plasma.tritanium",
    ["Spatially Enlarged Fluid"] = "spatialfluid",
    ["Tachyon Rich Temporal Fluid"] = "temporalfluid"
  }
}

local heliofusionExoticizerController = {}

---Crate new HeliofusionExoticizerController object from config
---@param config HeliofusionExoticizerControllerConfig
---@return HeliofusionExoticizerController
function heliofusionExoticizerController:newFormConfig(config)
  return self:new(
    config.magmatterMode,
    config.transposerAddress,
    config.outputMeInterfaceAddress,
    config.outputMeTransposerSide,
    config.mainMeInterfaceAddress,
    config.mainMeTransposerSide,
    config.plasmaFabricatorMeTransposerSide
  )
end

---Crate new HeliofusionExoticizerController object
---@param magmatterMode boolean
---@param transposerAddress string
---@param outputMeInterfaceAddress string
---@param outputMeTransposerSide number
---@param mainMeInterfaceAddress string
---@param mainMeTransposerSide number
---@param plasmaFabricatorMeTransposerSide number
---@return HeliofusionExoticizerController
function heliofusionExoticizerController:new(
  magmatterMode,
  transposerAddress,
  outputMeInterfaceAddress,
  outputMeTransposerSide,
  mainMeInterfaceAddress,
  mainMeTransposerSide,
  plasmaFabricatorMeTransposerSide)

  ---@class HeliofusionExoticizerController
  local obj = {}

  obj.outputMeInterfaceProxy = nil
  obj.mainMeInterfaceProxy = nil
  obj.transposerProxy = nil

  obj.magmatterMode = magmatterMode

  obj.database = component.database

  obj.stateMachine = stateMachineLib:new()

  obj.plasmaList = {}

  ---Init
  function obj:init()
    self.transposerProxy = componentDiscoverLib.discoverProxy(transposerAddress, "Transposer", "transposer")

    self.outputMeInterfaceProxy = componentDiscoverLib.discoverProxy(outputMeInterfaceAddress, "Output ME Interface", "me_interface")
    self.outputMeTransposerSide = outputMeTransposerSide

    self.mainMeInterfaceProxy = componentDiscoverLib.discoverProxy(mainMeInterfaceAddress, "Main ME Interface", "me_interface")
    self.mainMeTransposerSide = mainMeTransposerSide

    self.plasmaFabricatorMeTransposerSide = plasmaFabricatorMeTransposerSide

    self.stateMachine.data.challengeOutputs = nil
    self.stateMachine.data.craftFailCount = 0
    self.stateMachine.data.time = computer.uptime()
    self.stateMachine.data.notifyLongIdle = false
    self.stateMachine.data.notifyLongEndTime = false

    self:fillDatabase(self.magmatterMode and "Magmatter" or "Gluon")
    self:clearInterfaceConfigs(self.outputMeInterfaceProxy)
    self:clearInterfaceConfigs(self.mainMeInterfaceProxy)

    ---Idle state is the default state where we loop and check for challengeOutputs to trigger the solving challenge state
    self.stateMachine.states.idle = self.stateMachine:createState("Idle")
    self.stateMachine.states.idle.init = function()
      self.stateMachine.data.time = computer.uptime()
      self.stateMachine.data.notifyLongIdle = false

      if self.stateMachine.data.notifyLongEndTime == true then
        event.push("log_warning", "Successfully went to Idle state after a long Wait End state")
      end
    end
    self.stateMachine.states.idle.update = function()
      local items, itemsCount = self:getChallengeOutputs()
      local diff = math.ceil(computer.uptime() - self.stateMachine.data.time)

      if itemsCount >= (self.magmatterMode == true and 3 or 7) then
        self.stateMachine.data.challengeOutputs = items
        self.stateMachine:setState(self.stateMachine.states.solvingChallenge)
      elseif diff > 240 and self.stateMachine.data.notifyLongIdle == false then
        self.stateMachine.data.notifyLongIdle = true
        event.push("log_warning", "More than four minutes in the idle state: "..diff)
      end
    end

    ---The Solving Challenge state is where we solve the challenge by requesting the right inputs to send to the Plasma Fabricator
    self.stateMachine.states.solvingChallenge = self.stateMachine:createState("Solving Challenge")
    self.stateMachine.states.solvingChallenge.init = function()
      if self.stateMachine.data.notifyLongIdle == true then
        event.push("log_warning", "Successfully went to Solving Challenge state after a long Idle state")
      end

      local success, outputsCount = self:solveChallenge(self.stateMachine.data.challengeOutputs)

      if success == false then
        self.stateMachine.data.errorMessage = "Found an unidentified object in the output subnet"
        self.stateMachine:setState(self.stateMachine.states.error)
        return
      end

      local expectedCount = self.magmatterMode == true and 3 or 7

      if outputsCount ~= expectedCount then
        self.stateMachine.data.errorMessage = "Number of objects ("..outputsCount..") doesn't match the expected ("..expectedCount..")"
        self.stateMachine:setState(self.stateMachine.states.error)
        return
      end

      self.stateMachine:setState(self.stateMachine.states.idle)
    end

    self.stateMachine.states.error = self.stateMachine:createState("Error")
    self.stateMachine.states.error.init = function()
      event.push("log_error", self.stateMachine.data.errorMessage)
      event.push("log_info","&red;Press Enter to confirm")

      self.stateMachine.data.errorMessage = nil
    end

    self.stateMachine:setState(self.stateMachine.states.idle)
  end

  ---Loop
  function obj:loop()
    self.stateMachine:update()
  end

  ---Reset error state
  function obj:resetError()
    if self.stateMachine.currentState == self.stateMachine.states.error then
      self.stateMachine:setState(self.stateMachine.states.idle)
    end
  end

  ---Fill database with all possible plasmas depending on mode
  ---@private
  function obj:fillDatabase(mode)
    -- Leaving one space at the beginning of the database for other future usage
    local databaseIndex = 2

    for key, value in pairs(plasmaList[mode]) do
      local result = self.database.set(databaseIndex, "ae2fc:fluid_drop", 0, "{Fluid:\""..value.."\"}")

      if result == false then
        error("Cant save "..key.." to database")
      end

      self.plasmaList[key] = {databaseIndex = databaseIndex, fluid = value}

      databaseIndex = databaseIndex + 1
    end
  end

  ---Clear ME interface configs
  ---@param interfaceProxy table
  ---@private
  function obj:clearInterfaceConfigs(interfaceProxy)
    for i = 1, 9, 1 do
      interfaceProxy.setInterfaceConfiguration(i)
      if i >= 6 then
        interfaceProxy.setFluidInterfaceConfiguration(i)
      end
    end
  end

  ---Solve the challenge with the right plasmas
  ---@param outputs table<string, OutputItem>
  ---@return boolean
  ---@return integer
  ---@private
  function obj:solveChallenge(outputs)
    local index = 1

    for key, value in pairs(outputs) do
      local amountToRequest = 0
      local ingotsOfPlasmaPerDust = 9
      local litersOfPlasmaPerFluid = 1000

      -- We only need to calculate the amount of dust required in magmatter mode, for the rest we just need to send the challengeOutputs given to the plasma fabricator
      if self.magmatterMode == true and (key ~= "Spatially Enlarged Fluid" and key ~= "Tachyon Rich Temporal Fluid") then
        amountToRequest = math.abs(outputs["Spatially Enlarged Fluid"].count - outputs["Tachyon Rich Temporal Fluid"].count)
      elseif value.isLiquid == true then
        amountToRequest = value.count * litersOfPlasmaPerFluid
      else
        amountToRequest = value.count * ingotsOfPlasmaPerDust
      end

      if self.plasmaList[value.label] ~= nil then
        event.push("log_info", "Requesting "..amountToRequest.." of "..value.label.." from Main AE network")
        -- We're done, empty out the output subnet so the next challenge can start
        -- Configure outputMeInterfaceAddress to stock those fluids/items and their count value to be sent to the plasma fabricator.
        -- then use transposerAddress to move them into the plasmaInputInterfaceAddress from both the main net to plasma net
        os.sleep(30)
      else
        return false, index - 1
      end

      index = index + 1
    end

    return true, index - 1
  end

  ---Get items and liquids from output AE for to solve the challenge
  ---@return table<string, OutputItem>
  ---@return number
  ---@private
  function obj:getChallengeOutputs()
    local items = obj.outputMeInterfaceProxy.getItemsInNetwork({})
    local liquids = obj.outputMeInterfaceProxy.getFluidsInNetwork()

    ---@type table<string, OutputItem>
    local outputs = {}
    local count = 0

    for _, value in pairs(items) do
      event.push("log_debug", "Found "..value.size.." of "..value.label.." in output ME network")

      local label = value.label:match("Pile of%s(.+)%sDust")

      if label == nil then
        label = value.label:match("(.+) Dust")
      end

      if label == nil then
        outputs[value.label] = {label = value.label, count = value.size, isLiquid = false}
      else
        outputs[label] = {label = label, count = value.size, isLiquid = false}
      end

      count = count + 1
    end

    for _, value in pairs(liquids) do
      event.push("log_debug", "Found "..value.amount.." of "..value.label.." in output ME network")

      local label = value.label:match("^(.-)%s?[Gg]?[Aa]?[Ss]?$")

      if label == nil then
        outputs[value.label] = {label = value.label, count = value.amount, isLiquid = true}
      else
        outputs[label] = {label = label, count = value.amount, isLiquid = true}
      end

      count = count + 1
    end

    return outputs, count
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end


return heliofusionExoticizerController