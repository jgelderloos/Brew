class Hops
    attr_reader :type
    attr_reader :alpha
    attr_reader :beta
    attr_reader :mass
    attr_reader :unit
    def initialize type, alpha, beta, mass = 0, unit = "oz"
        @hop_types = [ "chinook", "cascade", "east kent golding" ]
        @hop_units = { "oz" => 1, "g" => 0.035274 }
        
        set_type( type )  
        set_alpha( alpha )
        set_beta( beta )
        set_mass( mass )
        set_unit( unit )
    end
    
    def set_type type
        type = type.downcase
        raise "#{type} is not a valide hop type" if !@hop_types.include? type
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
    
    def convert_to unit
        unit = unit.downcase
        if @hop_units[unit]
            @mass = @hop_units[@unit] * @mass / @hop_units[unit]
            set_unit( unit )
        end
    end
    
    private :set_type
end 