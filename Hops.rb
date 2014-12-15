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
#   Class: Hops
#
#   Description:
#   Holds basic info about a type and amount of hops

class Hops
    attr_reader :type
    attr_reader :alpha
    attr_reader :beta
    attr_reader :mass
    attr_reader :unit
    def initialize type, alpha = nil, beta = nil, mass = 0, unit = "oz"

        fm = FileManager.new
        @hop_types = fm.read_hop_data
        @hop_units = { "oz" => 1, "g" => 0.035274 }
        
        set_type( type )

        alpha = @hop_types[type][0] if alpha == nil
        set_alpha( alpha )

        beta = @hop_types[type][1] if beta == nil
        set_beta( beta )

        set_mass( mass )
        set_unit( unit )
    end
    
    def set_type type
        type = type.downcase
        raise "#{type} is not a valid hop type" if !@hop_types.include? type
        @type = type
    end
    
    def set_alpha alpha
        raise "#{alpha} is not a float value" if !alpha.is_a? Numeric
        @alpha = alpha.abs
    end
    
    def set_beta beta
        raise "#{beta} is not a numeric value" if !beta.is_a? Numeric
        @beta = beta.abs
    end
    
    def set_mass mass
        raise "#{mass} is not a numeric value" if !mass.is_a? Numeric
        @mass = mass.abs
    end
    
    def set_unit unit
        unit = unit.downcase
        raise "#{unit} is not a valid mass unit" if !@hop_units.assoc(unit)
        @unit = @hop_units.assoc(unit)[0]
    end

    def convert_to! unit
        new_mass = convert_to(unit)
        if new_mass != nil
            @mass = new_mass
            set_unit(unit)
        end
    end
    
    def convert_to unit
        unit = unit.downcase
        new_mass = nil
        new_mass = @hop_units[@unit] * @mass / @hop_units[unit] if @hop_units[unit]
    end
    
    private :set_type
end 
