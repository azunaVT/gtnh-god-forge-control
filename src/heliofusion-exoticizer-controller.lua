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
    ["Aluminium"] = "plasma.Aluminium",
    ["Americium"] = "plasma.Americium",
    ["Antimony"] = "plasma.Antimony",
    ["Ardite"] = "plasma.Ardite",
    ["Argon"] = "plasma.Argon",
    ["Arsenic"] = "plasma.Arsenic",
    ["Barium"] = "plasma.Barium",
    ["Beryllium"] = "plasma.Beryllium",
    ["Cadmium"] = "plasma.Cadmium",
    ["Caesium"] = "plasma.Caesium",
    ["Calcium"] = "plasma.Calcium",
    ["Carbon"] = "plasma.Carbon",
    ["Cerium"] = "plasma.Cerium",
    ["Chlorine"] = "plasma.Chlorine",
    ["Cobalt"] = "plasma.Cobalt",
    ["Copper"] = "plasma.Copper",
    ["Curium"] = "plasma.Curium",
    ["Desh"] = "plasma.Desh",
    ["Deuterium"] = "plasma.Deuterium",
    ["Dysprosium"] = "plasma.Dysprosium",
    ["Erbium"] = "plasma.Erbium",
    ["Europium"] = "plasma.Europium",
    ["Fluorine"] = "plasma.Fluorine",
    ["Gadolinium"] = "plasma.Gadolinium",
    ["Gallium"] = "plasma.Gallium",
    ["Germanium"] = "plasma.Germanium",
    ["Gold"] = "plasma.Gold",
    ["Hafnium"] = "plasma.Hafnium",
    ["Helium"] = "plasma.Helium",
    ["Holmium"] = "plasma.Holmium",
    ["Hydrogen"] = "plasma.Hydrogen",
    ["Indium"] = "plasma.Indium",
    ["Iodine"] = "plasma.Iodine",
    ["Iron"] = "plasma.Iron",
    ["Lanthanum"] = "plasma.Lanthanum",
    ["Lithium"] = "plasma.Lithium",
    ["Lutetium"] = "plasma.Lutetium",
    ["Magnesium"] = "plasma.Magnesium",
    ["Manganese"] = "plasma.Manganese",
    ["Mercury"] = "plasma.Mercury",
    ["Meteoric Iron"] = "plasma.MeteoricIron",
    ["Molybdenum"] = "plasma.Molybdenum",
    ["Neodymium"] = "plasma.Neodymium",
    ["Nickel"] = "plasma.Nickel",
    ["Niobium"] = "plasma.Niobium",
    ["Nitrogen"] = "plasma.Nitrogen",
    ["Oriharukon"] = "plasma.Oriharukon",
    ["Palladium"] = "plasma.Palladium",
    ["Phosphorus"] = "plasma.Phosphorus",
    ["Potassium"] = "plasma.Potassium",
    ["Praseodymium"] = "plasma.Praseodymium",
    ["Promethium"] = "plasma.Promethium",
    ["Radon"] = "plasma.Radon",
    ["Raw Silicon"] = "plasma.Silicon",
    ["Rhenium"] = "plasma.Rhenium",
    ["Rhodium"] = "plasma.Rhodium",
    ["Rubidium"] = "plasma.Rubidium",
    ["Ruthenium"] = "plasma.Ruthenium",
    ["Samarium"] = "plasma.Samarium",
    ["Silver"] = "plasma.Silver",
    ["Sodium"] = "plasma.Sodium",
    ["Strontium"] = "plasma.Strontium",
    ["Sulfur"] = "plasma.Sulfur",
    ["Tantalum"] = "plasma.Tantalum",
    ["Tellurium"] = "plasma.Tellurium",
    ["Terbium"] = "plasma.Terbium",
    ["Thallium"] = "plasma.Thallium",
    ["Thorium 232"] = "plasma.Thorium232",
    ["Thulium"] = "plasma.Thulium",
    ["Tin"] = "plasma.Tin",
    ["Titanium"] = "plasma.Titanium",
    ["Tritium"] = "plasma.Tritium",
    ["Tungsten"] = "plasma.Tungsten",
    ["Uranium 235"] = "plasma.Uranium235",
    ["Uranium 238"] = "plasma.Uranium",
    ["Vanadium"] = "plasma.Vanadium",
    ["Ytterbium"] = "plasma.Ytterbium",
    ["Yttrium"] = "plasma.Yttrium",
    ["Zinc"] = "plasma.Zinc",
    ["Zirconium"] = "plasma.Zirconium"
  },
  ["Magmatter"] = {
    ["Awakened Draconium"] = "plasma.DraconiumAwakened",
    ["Bedrockium"] = "plasma.Bedrockium",
    ["Celestial Tungsten"] = "plasma.CelestialTungsten",
    ["Chromatic Glass"] = "plasma.ChromaticGlass",
    ["Cosmic Neutronium"] = "plasma.CosmicNeutronium",
    ["Draconium"] = "plasma.Draconium",
    ["Dragonblood"] = "plasma.Dragonblood",
    ["Flerovium"] = "plasma.Flerovium_gt5u",
    ["Hypogen"] = "plasma.Hypogen",
    ["Ichorium"] = "plasma.Ichorium",
    ["Infinity"] = "plasma.Infinity",
    ["Neutronium"] = "plasma.Neutronium",
    ["Rhugnor"] = "plasma.Rhugnor",
    ["Six-Phased Copper"] = "plasma.SixPhasedCopper",
    ["Tritanium"] = "plasma.Tritanium",
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

      if self.database.get(2) ~= nil and self.possibleInputsList[1] == nil then
        for i = 2, 80 do
          local storedItem = self.database.get(i)
          local material = storedItem.label:match("(.+) Plasma Cell")
          local normalizedPlasmaName = string.lower(string.gsub(material, "[ -]", ""))
          self.possibleInputsList[material] = {databaseIndex = i, fluid = "plasma."..normalizedPlasmaName}
        end
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
      self.possibleInputsSolved = 0
      self.totalPossibleInputs = self.magmatterMode == true and 16 or 80

      -- Leave the first slot empty.
      self.nextDatabaseIndex = 2

      -- Start the damageIndex at 31k, this is where the plasmas starts for gregtech metaitems, this needs to be tweaked in the future.
      self.damageIndex = 31000

      self.maxRetries = 100
      self.retries = 0

      -- Try to solve some of the GT++ plasmas first, since they're predictable, this should only be done once
      local mode = self.magmatterMode == true and "Magmatter" or "Gluon"
      for plasmaName, _ in pairs(possibleInputs[mode]) do
        local normalizedPlasmaName = string.gsub(plasmaName, "[ -]", "")
        local result = self.database.set(self.nextDatabaseIndex, "miscutils:itemCellPlasma"..normalizedPlasmaName, 0)

        if result == true then
          self.possibleInputsSolved = self.possibleInputsSolved + 1
          self.nextDatabaseIndex = self.nextDatabaseIndex + 1
          event.push("log_info", "Added "..plasmaName.." to database. "..self.possibleInputsSolved.."/"..self.totalPossibleInputs)
        end
      end
    end
    self.stateMachine.states.fillingDatabase.update = function()
      local mode = self.magmatterMode == true and "Magmatter" or "Gluon"

      -- Solve the remaining plasmas by iterating over damaged gt meta items, we only support .01 items for now, the rest will need to be added manually.
      if (self.possibleInputsSolved < self.totalPossibleInputs) or (self.retries < self.maxRetries) then
        local result = self.database.set(self.nextDatabaseIndex, "gregtech:gt.metaitem.01", self.damageIndex)

        if result == true then
          local storedItem = self.database.get(self.nextDatabaseIndex)

          if storedItem ~= nil and storedItem.label ~= nil then
            local plasmaName = storedItem.label:match("(.+) Plasma Cell")

            if plasmaName ~= nil and possibleInputs[mode][plasmaName] ~= nil then
              local normalizedPlasmaName = string.gsub(plasmaName, "[ -]", "")

              self.possibleInputsSolved = self.possibleInputsSolved + 1
              self.nextDatabaseIndex = self.nextDatabaseIndex + 1
              self.retries = 0

              event.push("log_info", "Added "..plasmaName.." to database. "..self.possibleInputsSolved.."/"..self.totalPossibleInputs)
            else
              self.retries = self.retries + 1
            end
          end
        end

        self.damageIndex = self.damageIndex + 1
      else
        local foundAllPlasmas = true
        -- Print the list of missing plasmas that couldn't be added to the database, so they can be added manually if needed
        for k, v in pairs(possibleInputs[mode]) do
          if self.possibleInputsList[k] == nil then
            event.push("log_warning", "Couldn't find plasma "..k.." in the database, it won't be possible to solve challenges requiring it")
            foundAllPlasmas = false
          end
        end

        if foundAllPlasmas == true then
          event.push("log_info", "Successfully added all possible inputs to the database, moving to Idle state")
        else
          error("Couldn't find all plasmas in the database, missing plasmas need to be added manually before being able to solve all challenges")
        end

        self.stateMachine:setState(self.stateMachine.states.idle)
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

      outputs[label] = {label = label, count = value.size, isLiquid = false}

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