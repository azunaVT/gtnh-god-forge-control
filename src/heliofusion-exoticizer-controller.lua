local component = require("component")
local event = require("event")
local computer = require("computer")

local stateMachineLib = require("lib.state-machine-lib")
local componentDiscoverLib = require("lib.component-discover-lib")

---@class HeliofusionExoticizerControllerConfig
---@field magmatterMode boolean
---@field outputMeDriveSide number
---@field mainIoPortSide number

---@class OutputItem
---@field label string
---@field count number
---@field isLiquid boolean

---@type table<"Gluon"|"Magmatter", string[]>
local possibleInputs = {
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
    config.outputMeDriveSide,
    config.mainIoPortSide
  )
end

---Crate new HeliofusionExoticizerController object
---@param magmatterMode boolean
---@param outputMeDriveSide number
---@param mainIoPortSide number
---@return HeliofusionExoticizerController
function heliofusionExoticizerController:new(
  magmatterMode,
  outputMeDriveSide,
  mainIoPortSide)

  ---@class HeliofusionExoticizerController
  local obj = {}

  obj.outputMeInterfaceProxy = nil
  obj.mainMeInterfaceProxy = nil
  obj.transposerProxy = nil

  obj.magmatterMode = magmatterMode

  obj.database = component.database

  obj.stateMachine = stateMachineLib:new()

  obj.possibleInputsList = {}

  ---Init
  function obj:init()
    local transposerAddress = component.transposer.address
    self.transposerProxy = componentDiscoverLib.discoverProxy(transposerAddress, "Transposer", "transposer")

    local meInterfaceAddress = component.me_interface.address
    self.outputMeInterfaceProxy = componentDiscoverLib.discoverProxy(meInterfaceAddress, "Output ME Interface", "me_interface")
    self.outputMeDriveSide = outputMeDriveSide
    self.mainIoPortSide = mainIoPortSide

    local hubAddress = component.iohub.address
    self.hub = componentDiscoverLib.discoverProxy(hubAddress, "IO Hub", "iohub")

    self.stateMachine.data.challengeOutputs = nil
    self.stateMachine.data.craftFailCount = 0
    self.stateMachine.data.time = computer.uptime()
    self.stateMachine.data.notifyLongIdle = false
    self.stateMachine.data.notifyLongEndTime = false

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
      if self.database.get(2) == nil then
        event.push("log_warning", "Database is empty, filling it before being able to solve any challenge")
        self.stateMachine:setState(self.stateMachine.states.fillingDatabase)
        return
      end

      local items, itemsCount = self:getChallengeOutputs()
      local diff = math.ceil(computer.uptime() - self.stateMachine.data.time)

      if itemsCount >= (self.magmatterMode == true and 3 or 7) then
        self.stateMachine.data.challengeOutputs = items

        self:clearOutputs()

        self.stateMachine:setState(self.stateMachine.states.solvingChallenge)
      elseif diff > 240 and self.stateMachine.data.notifyLongIdle == false then
        self.stateMachine.data.notifyLongIdle = true
        event.push("log_warning", "More than four minutes in the idle state: "..diff)
      end
    end

    ---Filling Database state is where we fill the database with all the possible plasmas to be able to request them later when solving the challengeOutputs
    self.stateMachine.states.fillingDatabase = self.stateMachine:createState("Filling Database")
    self.stateMachine.states.fillingDatabase.init = function()
      self:fillDatabase(self.magmatterMode)
      self.stateMachine:setState(self.stateMachine.states.idle)
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
  ---@param isMagmatterMode boolean true for magmatter mode, false for gluon mode
  ---@private
  function obj:fillDatabase(isMagmatterMode)
    -- Leaving one space at the beginning of the database for other future usage
    local databaseIndex = 2
    local index = 1
    local mode = isMagmatterMode == true and "Magmatter" or "Gluon"
    local possibleInputsSolved = 0

    while possibleInputsSolved < #possibleInputs[mode] do
      local result = self.database.set(databaseIndex, "gregtech:gt.metaitem.01", index)

      -- if we stored an item, we check it against the possibleInputs list to match it with one of the plasmas based on the fluid_name
      if result == true then
        local storedItem = self.database.get(databaseIndex)
        for k, v in pairs(possibleInputs[mode]) do
          if storedItem ~= nil and storedItem.fluid_name == v then
            possibleInputsSolved = possibleInputsSolved + 1
            self.possibleInputsList[k] = {databaseIndex = databaseIndex, fluid = v}
            break
          end
        end
      end

      index = index + 1
    end
  end

  ---Move items from a source to a destination
  ---@param label string
  ---@param sourceProxy table
  ---@param sourceSide number
  ---@param destinationSide number
  ---@param amount number
  ---@param isFluid boolean
  ---@return boolean
  ---@return integer
  ---@private
  function obj:transferItemsOrFluids(label, sourceProxy, sourceSide, destinationSide, amount, isFluid)
    local amountMoved = 0

    if isFluid == true then
      event.push("log_info", "Transferring "..amount.."L of "..label.." from side "..sourceSide.." to side "..destinationSide)
      sourceProxy.setFluidInterfaceConfiguration(0, self.database.address, self.possibleInputsList[label].databaseIndex)
    else
      event.push("log_info", "Transferring "..amount.." of "..label.." from side "..sourceSide.." to side "..destinationSide)
      sourceProxy.setInterfaceConfiguration(1, self.database.address, self.possibleInputsList[label].databaseIndex, 64)
    end

    local result = true
    while amountMoved < amount do
      local transferredAmount = 0
      local amountToRequest = amount - amountMoved
      if isFluid == true then
        local fluidInTank = self.transposerProxy.getFluidInTank(sourceSide, 1)
        if fluidInTank == nil then
          result = false
          break
        end

        local _, tAmount = self.transposerProxy.transferFluid(sourceSide, destinationSide, amountToRequest, 0)
        transferredAmount = tAmount
      else
        local stackInSlot = self.transposerProxy.getStackInSlot(sourceSide, 1)
        if stackInSlot == nil then
          result = false
          break
        end

        transferredAmount = self.transposerProxy.transferItem(sourceSide, destinationSide, amountToRequest, 1)
      end

      amountMoved = amountMoved + transferredAmount
    end

    return result, amountMoved
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
      local litersPerIngotOfPlasma = 144
      local litersOfPlasmaPerFluid = 1000

      event.push("log_info", "Processing "..value.count.." of "..value.label.." from challenge outputs")

      -- We only need to calculate the amount of dust required in magmatter mode, for the rest we just need to send the challengeOutputs given to the plasma fabricator
      if self.magmatterMode == true and (key ~= "Spatially Enlarged Fluid" and key ~= "Tachyon Rich Temporal Fluid") then
        amountToRequest = math.abs(outputs["Spatially Enlarged Fluid"].count - outputs["Tachyon Rich Temporal Fluid"].count)
      elseif value.isLiquid == true then
        amountToRequest = value.count * litersOfPlasmaPerFluid
      else
        amountToRequest = value.count * ingotsOfPlasmaPerDust * litersPerIngotOfPlasma
      end

      if self.possibleInputsList[value.label] ~= nil then
        local amountMoved = self.hub.requestFluids(self.database.address, self.possibleInputsList[value.label].databaseIndex, amountToRequest)

        if amountMoved ~= amountToRequest then
          error("Failed to request "..value.label..": "..tostring(amountMoved).." moved out of "..tostring(amountToRequest))
        end
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
      event.push("log_info", "Found "..value.size.." of "..value.label.." in output ME network")

      -- normalize label to remove the " Dust" suffix for easier handling later
      local label = value.label:match("(.+) Dust")

      outputs[value.label] = {label = label, count = value.size, isLiquid = false}

      count = count + 1
    end

    for _, value in pairs(liquids) do
      event.push("log_info", "Found "..value.amount.." of "..value.label.." in output ME network")

      outputs[value.label] = {label = value.label, count = value.amount, isLiquid = true}

      count = count + 1
    end

    return outputs, count
  end

  ---Clear output ae by move items in input ae
  ---@private
  function obj:clearOutputs()
    for i = 1, 3, 1 do
      self.transposerProxy.transferItem(self.outputMeDriveSide, self.mainIoPortSide, 1)
    end

    while self.transposerProxy.getSlotStackSize(self.mainIoPortSide, 9) ~= 1 do
      os.sleep(0.1)
    end

    for i = 1, 3, 1 do
      self.transposerProxy.transferItem(self.mainIoPortSide, self.outputMeDriveSide, 1)
    end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end


return heliofusionExoticizerController