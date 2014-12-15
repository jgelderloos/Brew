#   Copyright 2014 jgelderloos
#   
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Class: Water
#
#   Description:
#   Holds basic info about a volume of water

class Water
    attr_accessor :volume
    attr_reader   :unit

    def initialize volume = 0, unit = "gal"
        @water_units = { "gal" => 1, "qts" => 0.25 }
        
        set_volume( volume )
        set_unit( unit )
    
    end
    
    def set_volume volume
        raise "#{volume} is not a valid numeric value" if !volume.is_a? Numeric
        @volume = volume.abs
    end
    
    def set_unit unit
        unit = unit.downcase
        raise "#{unit} is not a valid volume unit" if !@water_units.assoc(unit)
        @unit = @water_units.assoc(unit)[0]
    end
    
    def convert_to! unit
        vol = convert_to( unit )
        if vol != nil
            @volume = vol
            set_unit(unit)
        end
    end
    
    def convert_to unit
        unit = unit.downcase
        vol = nil
        if @water_units[unit]
            vol = @water_units[@unit] * @volume / @water_units[unit]
        end
    end
    
    def add volume
        @volume += volume
        @volume += @volume * -1 if @volume < 0
    end
    
    def remove volume
        @volume -= volume
        @volume += @volume * -1 if @volume < 0
    end
end