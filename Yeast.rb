class Yeast
    attr_reader   :name
    attr_accessor :percent_attenuation
    def initialize name, attenuation = 75
        @name = name.to_s
        @percent_attenuation = attenuation.abs
    end
    
    def set_name name
        @name = name.to_s
    end

end