--[[ Copyright (C) 2018 Google Inc.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]

local make_map = require 'common.make_map'
local game = require 'dmlab.system.game'
local pickups = require 'common.pickups'
local helpers = require 'common.helpers'
local custom_observations = require 'decorators.custom_observations'
local setting_overrides = require 'decorators.setting_overrides'
local timeout = require 'decorators.timeout'
local random = require 'common.random'
local map_maker = require 'dmlab.system.map_maker'
local randomMap = random(map_maker:randomGen())

local factory = {}

--[[ Creates a Seek Avoid API.
Keyword arguments:

*   `mapName` (string) - Name of map to load.
*   `episodeLengthSeconds` (number) - Episode length in seconds.
]]



local MAP_ENTITIES = [[
  *********************
  *A P*P P*P P P P P P*
  * * * ***** ***** * *
  *P*A*P*G A*P P P*P*P*
  * * * *   *     * * *
  *P*P P*A  *P P P*P*P*
  * *****   * *   * * *
  *P P  *   *P*P P*A*P*
  ***** * *********** *
  *P  P      P P P P P*
  *********************
]]



local MAP_VA1 = [[
 *********************
 *   *   *           *
 * * * ***** ***** * *
 * * * *   *     * * *
 * * * *   *     * * *
 * *   *   *     * * *
 * *****   * *   * * *
 *     *   * *   * * *
 ***** * *********** *
 *                   *
 *********************
]]


local MAP_VA = [[
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
  CCCCCCCCCCCCCCCCCCCCC
]]

function factory.createLevelApi(kwargs)
  assert(kwargs.mapName and kwargs.episodeLengthSeconds)

  local api = {}

  function api:init(params)
    make_map.seedRng(1)
    api._map = make_map.makeMap{
        mapName = "empty_room",
        mapEntityLayer = MAP_ENTITIES,
        mapVariationsLayer = MAP_VA,
        useSkybox = true,
    }
  end
  
  
  function api:createPickup(class) 
    return pickups.defaults[class]
  end
  
  function api:nextMap()
     
     local map = self._map
     self._map = ''
     return map
     --return self._map
  end
  
  function api:updateSpawnVars(spawnVars)
    if spawnVars.classname == "info_player_start" then
      -- Spawn facing East.
      spawnVars.angle = "0"
      spawnVars.randomAngleRange = "0"
    end
    return spawnVars
  end

  custom_observations.decorate(api)
  setting_overrides.decorate{
      api = api,
      apiParams = kwargs,
      decorateWithTimeout = true
  }
  return api
end

return factory
