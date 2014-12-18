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
#   Class: TestGrain
#
#   Description:
#   Unit tests for the Grain class

require "test/unit"

require_relative "Grain"

class TestGrain < Test::Unit::TestCase
    
    # Testing bad inits -----------------------------------

    def test_init_bad_type_1
        # Test passing bad type
        assert_raise RuntimeError do
            g = Grain.new( "blah" )
        end
    end

    def test_init_bad_type_2
        # Test passing nil type
        assert_raise NoMethodError do
            g = Grain.new( nil )
        end
    end

    def test_init_bad_mass_1    
        # Test passing bad mass type
        assert_raise NoMethodError do
            g = Grain.new( "wheat", "five" )
        end
    end

    def test_init_bad_mass_2 
        # Test passing nil mass
        assert_raise NoMethodError do
            g = Grain.new( "wheat", nil )
        end
    end

    def test_init_bad_unit_1
        # Test passong bad unit type
        assert_raise RuntimeError do
            g = Grain.new( "wheat", 0, "my_mass" )
        end
    end
    
    def test_init_bad_unit_2
        # Test passing nil to unit
        assert_raise NoMethodError do
            g = Grain.new( "wheat", 0, nil )
        end
    end
	
	def test_init_bad_ppg_1
        # Test passing bad ppg type
        assert_raise NoMethodError do
            g = Grain.new( "wheat", 0, "lbs", "forty five" )
        end
    end

    def test_init_bad_efficiency_1
        # Test passing bad efficiency type
        assert_raise NoMethodError do
            g = Grain.new( "wheat", 0, "lbs", 45, "seventy" )
        end
    end

    # Testing valid inputs -----------------------------------------------

    def test_init_good_type_1
        # Tests init with only type
        # Tests type with capital is matched to non-cap name
        # Tests values are loaded correctly
        g = Grain.new( "Vienna" )

        assert_equal( "vienna", g.type )
        assert_equal( 0, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_init_good_type_2
        # Create 2 grains to make sure we dont have any runtime errors
        # with the class var @@grain_types
        g1 = Grain.new( "wheat" )
        g2 = Grain.new( "vienna" )

        assert_equal( "wheat", g1.type )
        assert_equal( 0, g1.mass )
        assert_equal( "lbs", g1.unit )
        assert_equal( 45, g1.ppg_potential )
        assert_equal( 70, g1.percent_efficiency )

        assert_equal( "vienna", g2.type )
        assert_equal( 0, g2.mass )
        assert_equal( "lbs", g2.unit )
        assert_equal( 45, g2.ppg_potential )
        assert_equal( 70, g2.percent_efficiency )
    end

    def test_init_good_mass_1
        # Test setting the mass
        g = Grain.new( "wheat", 10 )

        assert_equal( "wheat", g.type )
        assert_equal( 10, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_init_good_mass_2
        # Test negative inputs made positive
        g = Grain.new( "wheat", -3.3 )

        assert_equal( "wheat", g.type )
        assert_equal( 3.3, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_init_good_unit_1
        # Test setting unit to lbs
        # Test downcasing of unit
        g = Grain.new( "wheat", 2, "Lbs" )

        assert_equal( "wheat", g.type )
        assert_equal( 2, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_init_good_unit_2
        # Test setting unit to kg
        g = Grain.new( "wheat", 2, "kg" )

        assert_equal( "wheat", g.type )
        assert_equal( 2, g.mass )
        assert_equal( "kg", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end
	
	def test_init_good_ppg_1
        # Tests setting the ppg different from default
        g = Grain.new( "wheat", 10, "lbs", 50 )

        assert_equal( "wheat", g.type )
        assert_equal( 10, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 50, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end
	
	def test_init_good_ppg_2
        # Tests setting the ppg negative
        g = Grain.new( "wheat", 10, "lbs", -20 )

        assert_equal( "wheat", g.type )
        assert_equal( 10, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 20, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_init_good_efficiency_1
        # Test setting the efficiency different from default
        g = Grain.new( "wheat", 5.6, "lbs", 45, 60)

        assert_equal( "wheat", g.type )
        assert_equal( 5.6, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 60, g.percent_efficiency )
    end
	
	def test_init_good_efficiency_2
        # Test setting the efficiency negative
        g = Grain.new( "wheat", 5.6, "lbs", 45, -30)

        assert_equal( "wheat", g.type )
        assert_equal( 5.6, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 30, g.percent_efficiency )
    end

    # Testing setters ----------------------------------------------
    
    def test_set_mass_bad_1
        # Test passing bad mass
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_mass( "one" )
        end
    end

    def test_set_mass_bad_2
        # Test passing nil
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_mass( nil )
        end
    end

    def test_set_unit_bad_1
        # Test passing bad unit
        g = Grain.new( "wheat" )

        assert_raise RuntimeError do
            g.set_unit( "oz" )
        end
    end

    def test_set_unit_bad_2
        # Test passing bad unit
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_unit( nil )
        end
    end
	
	def test_set_ppg_bad_1
        # Test passing bad ppg
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_ppg( "two" )
        end
    end

    def test_set_ppg_bad_2
        # Test passing nil
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_ppg( nil )
        end
    end

    def test_set_efficiency_bad_1
        # Test passing bad efficiency
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_efficiency( "zero" )
        end
    end

    def test_set_efficiency_bad_2
        # Test passing nil
        g = Grain.new( "wheat" )

        assert_raise NoMethodError do
            g.set_efficiency( nil )
        end
    end

    def test_set_mass_good_1
        # Tests passing int
        g = Grain.new( "wheat", 3.4 )
        g.set_mass( 2 )

        assert_equal( "wheat", g.type )
        assert_equal( 2, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_set_mass_good_2
        # Tests passsing negative float
        g = Grain.new( "wheat", 3.4 )
        g.set_mass( -1.5 )

        assert_equal( "wheat", g.type )
        assert_equal( 1.5, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_set_unit_good_1
        # Tests passing kg
        g = Grain.new( "wheat", 3.4, "lbs" )
        g.set_unit( "kg" )

        assert_equal( "wheat", g.type )
        assert_equal( 3.4, g.mass )
        assert_equal( "kg", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_set_unit_good_2
        # Tests passing lbs
        g = Grain.new( "wheat", 3.4, "kg" )
        g.set_unit( "lbs" )

        assert_equal( "wheat", g.type )
        assert_equal( 3.4, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end
	
	def test_set_ppg_good_1
        # Tests passing float
        g = Grain.new( "wheat", 3.4, "lbs", 45 )
        g.set_ppg( 32.2 )

        assert_equal( "wheat", g.type )
        assert_equal( 3.4, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 32.2, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_set_ppg_good_2
        # Tests passing negative and int
        g = Grain.new( "wheat", 2, "lbs", 45 )
        g.set_ppg( -2 )

        assert_equal( "wheat", g.type )
        assert_equal( 2, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 2, g.ppg_potential )
        assert_equal( 70, g.percent_efficiency )
    end

    def test_set_efficiency_good_1
        # Tests passing int
        g = Grain.new( "wheat", 3.4, "lbs", 45, 75 )
        g.set_efficiency( 50 )

        assert_equal( "wheat", g.type )
        assert_equal( 3.4, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 50, g.percent_efficiency )
    end

    def test_set_efficiency_good_2
        # Tests passing negative float
        g = Grain.new( "wheat", 3.4, "lbs", 45, 75 )
        g.set_efficiency( -60.3 )

        assert_equal( "wheat", g.type )
        assert_equal( 3.4, g.mass )
        assert_equal( "lbs", g.unit )
        assert_equal( 45, g.ppg_potential )
        assert_equal( 60.3, g.percent_efficiency )
    end

    # Testing conversion of units ------------------------------------

    def test_convert_to_bad_1
        # Tests passing bad unit
        g = Grain.new( "wheat", 3.4, "lbs" )
        mass = g.convert_to( "gal" )

        assert_equal( nil, mass )
    end

    def test_convert_to_bad_2
        # Tests passing nill
        g = Grain.new( "wheat", 3.4,"lbs" )
        
        assert_raise NoMethodError do
            mass = g.convert_to( nil )
        end
    end

    def test_bang_convert_to_bad_1
        # Tests passing bad unit
        g = Grain.new( "wheat", 3.4, "lbs" )
        g.convert_to!( "m3" )

        assert_equal( 3.4, g.mass )
        assert_equal( "lbs", g.unit )
    end

    def test_bang_convert_to_bad_2
        # Tests passing nil
        g = Grain.new( "wheat", 3.4, "lbs" )
        
        assert_raise NoMethodError do
            g.convert_to!( nil )
        end
        assert_equal( 3.4, g.mass )
        assert_equal( "lbs", g.unit )
    end

    def test_convert_to_good_1
        # Tests lbs to kg
        g = Grain.new( "wheat", 10, "lbs" )
        mass = g.convert_to( "kg" )

        assert_equal( 4.535918807053354, mass )
        assert_equal( 10, g.mass )
        assert_equal( "lbs", g.unit )
    end

    def test_convert_to_good_2
        # Tests kg to lbs
        g = Grain.new( "wheat", 4.535918807053354, "kg" )
        mass = g.convert_to( "lbs" )

        assert_equal( 10, mass )
        assert_equal( 4.535918807053354, g.mass )
        assert_equal( "kg", g.unit )
    end

    def test_bang_convert_to_good_1
        # Tests lbs to kg
        g = Grain.new( "wheat", 20, "lbs" )
        g.convert_to!( "kg" )

        assert_equal( 9.071837614106707, g.mass )
        assert_equal( "kg", g.unit )
    end

    def test_bang_convert_to_good_2
        # Tests kg to lbs
        g = Grain.new( "wheat", 9.071837614106707, "kg" )
        g.convert_to!( "lbs" )

        assert_equal( 20, g.mass )
        assert_equal( "lbs", g.unit )
    end
end

