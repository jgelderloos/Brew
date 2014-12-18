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
#   Class: TestHops
#
#   Description:
#   Unit tests for the Hops class

require "test/unit"

require_relative "Hops"

class TestHops < Test::Unit::TestCase
    
  # Testing bad inits --------------------------------------

  def test_init_bad_type_1
    # Test passing bad type
    assert_raise RuntimeError do
      h = Hops.new( "blah" )
    end
  end

  def test_init_bad_type_2
    # Test passing nil type
    assert_raise NoMethodError do
      h = Hops.new( nil )
    end
  end

  def test_init_bad_alpha_1
    # Test passing bad alpha type
    assert_raise NoMethodError do
      h = Hops.new( "chinook", "one", 0 )
    end
  end

  def test_init_bad_beta_1
    # Test passing bad beta type
    assert_raise NoMethodError do
      h = Hops.new( "chinook", 0, "five" )
    end
  end

  def test_init_bad_mass_1    
    # Test passing bad mass type
    assert_raise NoMethodError do
      h = Hops.new( "chinook", 0, 0, "five" )
    end
  end

  def test_init_bad_mass_2 
    # Test passing nil mass
    assert_raise NoMethodError do
      h = Hops.new( "chinook", 0, 0, nil )
    end
  end

  def test_init_bad_unit_1
    # Test passing bad unit type
    assert_raise RuntimeError do
      h = Hops.new( "chinook", 0, 0, 0, "my_mass" )
    end
  end
  
  def test_init_bad_unit_2
    # Test passing nil to unit
    assert_raise NoMethodError do
      h = Hops.new( "chinook", 0, 0, 0, nil )
    end
  end

  # Testing valid inputs -----------------------------------------------

  def test_init_good_type_1
    # Tests init with only type
    # Tests type with capital is matched to non-cap name
    # Tests alpha beta values are loaded correctly
    h = Hops.new( "Warrior" )

    assert_equal( "warrior", h.type )
    assert_equal( 15.7, h.alpha )
    assert_equal( 6.2, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_init_good_type_2
    # Create 2 hops to make sure we dont have any runtime errors
    # with the class var @@hops_types
    h1 = Hops.new( "simcoe" )
    h2 = Hops.new( "amarillo" )

    assert_equal( "simcoe", h1.type )
    assert_equal( 12.7, h1.alpha )
    assert_equal( 4, h1.beta )
    assert_equal( 0, h1.mass )
    assert_equal( "oz", h1.unit )

    assert_equal( "amarillo", h2.type )
    assert_equal( 8.2, h2.alpha )
    assert_equal( 6.2, h2.beta )
    assert_equal( 0, h2.mass )
    assert_equal( "oz", h2.unit )
  end

  def test_init_good_alpha_1
    # Tests setting the alpha different from default
    h = Hops.new( "chinook", 3.5 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.5, h.alpha )
    assert_equal( 10, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_init_good_beta_1
    # Test setting the beta different from default
    h = Hops.new( "chinook", 5.6,  7 )

    assert_equal( "chinook", h.type )
    assert_equal( 5.6, h.alpha )
    assert_equal( 7, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_init_good_mass_1
    # Test setting the mass
    h = Hops.new( "chinook", 5.6, 10, 2.25 )

    assert_equal( "chinook", h.type )
    assert_equal( 5.6, h.alpha )
    assert_equal( 10, h.beta )
    assert_equal( 2.25, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_init_good_alpha_beta_mass_negative_1
    # Test negative inputs made positive
    h = Hops.new( "chinook", -3.3, -7, -1 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.3, h.alpha )
    assert_equal( 7, h.beta )
    assert_equal( 1, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_init_good_unit_1
    # Test setting unit to oz
    # Test downcasing of unit
    h = Hops.new( "chinook", 2, 2, 1, "Oz" )

    assert_equal( "chinook", h.type )
    assert_equal( 2, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 1, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_init_good_unit_2
    # Test setting unit to g
    h = Hops.new( "chinook", 2, 2, 1, "g" )

    assert_equal( "chinook", h.type )
    assert_equal( 2, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 1, h.mass )
    assert_equal( "g", h.unit )
  end

  # Testing setters ----------------------------------------------
  
  def test_set_alpha_bad_1
    # Test passing bad alpha
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_alpha( "two" )
    end
  end

  def test_set_alpha_bad_2
    # Test passong nil
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_alpha( nil )
    end
  end

  def test_set_beta_bad_1
    # Test passing bad beta
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_beta( "zero" )
    end
  end

  def test_set_beta_bad_2
    # Test passing nil
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_beta( nil )
    end
  end

  def test_set_mass_bad_1
    # Test passing bad mass
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_mass( "one" )
    end
  end

  def test_set_mass_bad_2
    # Test passing nil
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_mass( nil )
    end
  end

  def test_set_unit_bad_1
    # Test passing bad unit
    h = Hops.new( "chinook" )

    assert_raise RuntimeError do
      h.set_unit( "lbs" )
    end
  end

  def test_set_unit_bad_2
    # Test passing bad unit
    h = Hops.new( "chinook" )

    assert_raise NoMethodError do
      h.set_unit( nil )
    end
  end

  def test_set_alpha_good_1
    # Tests passing float
    h = Hops.new( "chinook", 0 )
    h.set_alpha( 3.4 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 10, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_set_alpha_good_2
    # Tests passing negative and int
    h = Hops.new( "chinook", 0 )
    h.set_alpha( -2 )

    assert_equal( "chinook", h.type )
    assert_equal( 2, h.alpha )
    assert_equal( 10, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_set_beta_good_1
    # Tests passing int
    h = Hops.new( "chinook", 3.4, 5 )
    h.set_beta( 2 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_set_beta_good_2
    # Tests passing negative float
    h = Hops.new( "chinook", 3.4, 5 )
    h.set_beta( -6.3 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 6.3, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_set_mass_good_1
    # Tests passing int
    h = Hops.new( "chinook", 3.4, 2, 0 )
    h.set_mass( 2 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 2, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_set_mass_good_2
    # Tests passsing negative float
    h = Hops.new( "chinook", 3.4, 2, 0 )
    h.set_mass( -1.5 )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 1.5, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_set_unit_good_1
    # Tests passing G
    h = Hops.new( "chinook", 3.4, 2, 0 )
    h.set_unit( "g" )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "g", h.unit )
  end

  def test_set_unit_good_2
    # Tests passing oz
    h = Hops.new( "chinook", 3.4, 2, 0, "g" )
    h.set_unit( "oz" )

    assert_equal( "chinook", h.type )
    assert_equal( 3.4, h.alpha )
    assert_equal( 2, h.beta )
    assert_equal( 0, h.mass )
    assert_equal( "oz", h.unit )
  end

  # Testing conversion of units -------------------------------------

  def test_convert_to_bad_1
    # Tests passing bad unit
    h = Hops.new( "chinook", 3.4, 2, 1, "g" )
    mass = h.convert_to( "gal" )

    assert_equal( nil, mass )
  end

  def test_convert_to_bad_2
    # Tests passing nill
    h = Hops.new( "chinook", 3.4, 2, 1, "g" )
    
    assert_raise NoMethodError do
      mass = h.convert_to( nil )
    end
  end

  def test_bang_convert_to_bad_1
    # Tests passing bad unit
    h = Hops.new( "chinook", 3.4, 2, 1, "oz" )
    h.convert_to!( "m3" )

    assert_equal( 1, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_bang_convert_to_bad_2
    # Tests passing nil
    h = Hops.new( "chinook", 3.4, 2, 1, "oz" )
    
    assert_raise NoMethodError do
        h.convert_to!( nil )
    end
    assert_equal( 1, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_convert_to_good_1
    # Tests g to oz
    h = Hops.new( "chinook", 3.4, 2, 1, "g" )
    mass = h.convert_to( "oz" )

    assert_equal( 0.035274, mass )
    assert_equal( 1, h.mass )
    assert_equal( "g", h.unit )
  end

  def test_convert_to_good_2
    # Tests oz to g
    h = Hops.new( "chinook", 3.4, 2, 0.035274, "oz" )
    mass = h.convert_to( "g" )

    assert_equal( 1, mass )
    assert_equal( 0.035274, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_bang_convert_to_good_1
    # Tests g to oz
    h = Hops.new( "chinook", 3.4, 2, 2, "g" )
    h.convert_to!( "oz" )

    assert_equal( 0.070548, h.mass )
    assert_equal( "oz", h.unit )
  end

  def test_bang_convert_to_good_2
    # Tests oz to g
    h = Hops.new( "chinook", 3.4, 2,  0.070548, "oz" )
    h.convert_to!( "g" )

    assert_equal( 2, h.mass )
    assert_equal( "g", h.unit )
  end
end
