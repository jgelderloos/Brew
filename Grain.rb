class Grain
    attr_reader   :type
    attr_reader   :mass
    attr_reader   :unit
    attr_accessor :ppg_potential
    attr_accessor :percent_efficiency
    def initialize type, mass = 0, unit = "lbs", ppg = 45, efficiency = 70
        @grain_types = [ "wheat", "barley", "2 row", "vienna" ]
        @grain_units = { "lbs" => 1, "kg" => 2.204625}
        @ppg_potential = ppg.abs
        @percent_efficiency = efficiency.abs
    
        set_type( type )
        set_mass( mass )
        set_unit( unit )
        
    end
    
    def set_type type
        type = type.downcase
        raise "#{type} is not a valide grain type" if !@grain_types.include? type
        @type = type
    end
    
    def set_mass mass
        raise "#{mass} is not a numeric value" if !mass.is_a? Numeric
        @mass = mass.abs
    end
    
    def set_unit unit
        unit = unit.downcase
        raise "#{unit} is not a valid mass unit" if !@grain_units.assoc(unit)
        @unit = @grain_units.assoc(unit)[0]
    end
    
    def convert_to! unit
        lbs = convert_to(unit)
        if lbs != nil
            @mass = lbs
            set_unit( unit )
        end
    end
    
    def convert_to unit
        unit = unit.downcase
        lbs = nil
        if @grain_units[unit]
            lbs = @grain_units[@unit] * @mass / @grain_units[unit] 
        end
    end
    
    private :set_type
end