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
#   Class: TestWater
#
#   Description:
#   Unit tests for the Water class

require "test/unit"

require_relative "../lib/Water"

class TestWater < Test::Unit::TestCase
    
  # Testing bad inits -----------------------------------

  def test_init_bad_volume_1
    # Test passing bad volume
    assert_raise NoMethodError do
      w = Water.new( "blah" )
    end
  end

  def test_init_bad_volume_2
    # Test passing nil volume
    assert_raise NoMethodError do
      w = Water.new( nil )
    end
  end

  def test_init_bad_unit_1
    # Test passing bad unit type
    assert_raise RuntimeError do
      w = Water.new( 0, "my_mass" )
    end
  end
  
  def test_init_bad_unit_2
    # Test passing nil to unit
    assert_raise NoMethodError do
      w = Water.new( 0, nil )
    end
  end

  # Testing valid inputs -----------------------------------------------

  def test_init_good_1
    # Tests init with no params
    w = Water.new()

    assert_equal( 0, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_init_good_volume_1
    # Tests init with volume
    w = Water.new( 1 )

    assert_equal( 1, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_init_good_volume_2
    # Tests init with negative volume
    w = Water.new( -2.5 )

    assert_equal( 2.5, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_init_good_unit_1
    # Test setting unit to gal
    # Test downcasing of unit
    w = Water.new( 2, "Gal" )

    assert_equal( 2, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_init_good_unit_2
    # Test setting unit to qts
    w = Water.new( 2, "qts" )

    assert_equal( 2, w.volume )
    assert_equal( "qts", w.unit )
  end

  # Testing setters ----------------------------------------------
  
  def test_set_volume_bad_1
    # Test passing bad volume
    w = Water.new()

    assert_raise NoMethodError do
      w.set_volume( "one" )
    end
  end

  def test_set_volume_bad_2
    # Test passing nil
    w = Water.new()

    assert_raise NoMethodError do
      w.set_volume( nil )
    end
  end

  def test_set_unit_bad_1
    # Test passing bad unit
    w = Water.new()

    assert_raise RuntimeError do
      w.set_unit( "oz" )
    end
  end

  def test_set_unit_bad_2
    # Test passing bad unit
    w = Water.new()

    assert_raise NoMethodError do
      w.set_unit( nil )
    end
  end

  def test_set_volume_good_1
    # Tests passing int
    w = Water.new( 5 )
    w.set_volume( 2 )

    assert_equal( 2, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_set_volume_good_2
    # Tests passsing negative float
    w = Water.new( 5 )
    w.set_volume( -1.5 )

    assert_equal( 1.5, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_set_unit_good_1
    # Tests passing qts
    w = Water.new( 0, "gal" )
    w.set_unit( "qts" )

    assert_equal( 0, w.volume )
    assert_equal( "qts", w.unit )
  end

  def test_set_unit_good_2
    # Tests passing gal
    w = Water.new( 0, "qts" )
    w.set_unit( "gal" )

    assert_equal( 0, w.volume )
    assert_equal( "gal", w.unit )
  end

  # Testing conversion of units ------------------------------------

  def test_convert_to_bad_1
    # Tests passing bad unit
    w = Water.new( 5, "gal" )
    volume = w.convert_to( "lbs" )

    assert_equal( nil, volume )
  end

  def test_convert_to_bad_2
    # Tests passing nill
    w = Water.new( 5, "gal" )
    
    assert_raise NoMethodError do
      volume = w.convert_to( nil )
    end
  end

  def test_bang_convert_to_bad_1
    # Tests passing bad unit
    w = Water.new( 5, "gal" )
    w.convert_to!( "m3" )

    assert_equal( 5, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_bang_convert_to_bad_2
    # Tests passing nil
    w = Water.new( 5, "gal" )
    
    assert_raise NoMethodError do
        w.convert_to!( nil )
    end
    assert_equal( 5, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_convert_to_good_1
    # Tests gal to qts
    w = Water.new( 5, "gal" )
    volume = w.convert_to( "qts" )

    assert_equal( 20, volume )
    assert_equal( 5, w.volume )
    assert_equal( "gal", w.unit )
  end

  def test_convert_to_good_2
    # Tests qts to gal
    w = Water.new( 20, "qts" )
    volume = w.convert_to( "gal" )

    assert_equal( 5, volume )
    assert_equal( 20, w.volume )
    assert_equal( "qts", w.unit )
  end

  def test_bang_convert_to_good_1
    # Tests gal to qts
    w = Water.new( 10, "gal" )
    w.convert_to!( "qts" )

    assert_equal( 40, w.volume )
    assert_equal( "qts", w.unit )
  end

  def test_bang_convert_to_good_2
    # Tests qts to gal
    w = Water.new( 40, "qts" )
    w.convert_to!( "gal" )

    assert_equal( 10, w.volume )
    assert_equal( "gal", w.unit )
  end

# Testing add and remove volume -----------------------------

  def test_add_bad_1
    # Tests passing bad volume
    w = Water.new( 5, "gal" )

    assert_raise TypeError do
      w.add( "two" )
    end
  end

  def test_add_bad_2
    # Tests passing nil
    w = Water.new( 5, "gal" )

    assert_raise TypeError do
      w.add( nil )
    end
  end

  def test_remove_bad_1
    # Tests passing bad volume
    w = Water.new( 5, "gal" )

    assert_raise TypeError do
      w.remove( "three" )
    end
  end

  def test_remove_bad_2
    # Tests passing nil
    w = Water.new( 5, "gal" )

    assert_raise TypeError do
      w.remove( nil )
    end
  end

  def test_add_good_1
    # Tests passing int
    w = Water.new( 5, "gal" )
    w.add( 2 )

    assert_equal( 7, w.volume )
  end

  def test_add_good_2
    # Tests passing negative float
    w = Water.new( 5, "gal" )
    w.add( -0.5 )

    assert_equal( 4.5, w.volume )
  end

  def test_remove_good_1
    # Tests passing negative int
    w = Water.new( 5, "gal" )
    w.remove( -3 )

    assert_equal( 8, w.volume )
  end

  def test_remove_good_2
    # Tests passing float
    w = Water.new( 5, "gal" )
    w.remove( 2.5 )

    assert_equal( 2.5, w.volume )
  end
end

