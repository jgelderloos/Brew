#   Copyright 2014 jgelderloos
#   
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://wwy.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Class: TestYeast
#
#   Description:
#   Unit tests for the Yeast class

require "test/unit"

require_relative "Yeast"

class TestYeast < Test::Unit::TestCase
    
  # Testing bad inits -----------------------------------

  def test_init_bad_1
    # Test passing nothing
    assert_raise ArgumentError do
      y = Yeast.new()
    end
  end

  def test_init_bad_attenuation_1
    # Test passing bad attenuation
    assert_raise NoMethodError do
      y = Yeast.new( "My Yeast", "ten" )
    end
  end
  
  def test_init_bad_attenuation_2
    # Test passing nil
    assert_raise NoMethodError do
      y = Yeast.new( "My Yeast", nil )
    end
  end

  # Testing valid inputs -----------------------------------------------

  def test_init_good_name_1
    # Tests init
    y = Yeast.new( "My Yeast")

    assert_equal( "My Yeast", y.name )
    assert_equal( 75, y.percent_attenuation )
  end
  
  def test_init_good_name_2
    # Test passing nil
    y = Yeast.new( nil )
    
    assert_equal( "", y.name )
    assert_equal( 75, y.percent_attenuation )
  end

  def test_init_good_attenuation_1
    # Tests init with attenuation
    y = Yeast.new( "My Yeast", 50 )

    assert_equal( "My Yeast", y.name )
    assert_equal( 50, y.percent_attenuation )
  end

  def test_init_good_attenuation_2
    # Tests init with negative float attenuation
    y = Yeast.new( "My Yeast", -82.3 )

    assert_equal( "My Yeast", y.name )
    assert_equal( 82.3, y.percent_attenuation )
  end

  # Testing setters ----------------------------------------------

  def test_set_attenuation_bad_1
    # Test passing bad attenuation
    y = Yeast.new( "My Yeast" )

    assert_raise NoMethodError do
      y.set_attenuation( "one" )
    end
  end

  def test_set_attenuation_bad_2
    # Test passing nil
    y = Yeast.new( "My Yeast" )

    assert_raise NoMethodError do
      y.set_attenuation( nil )
    end
  end

  def test_set_name_good_1
    # Tests passing int
    y = Yeast.new( "My Yeast" )
    y.set_name( "New Name" )

    assert_equal( "New Name", y.name )
    assert_equal( 75, y.percent_attenuation )
  end
  
  def test_set_name_good_2
    # Test passing nil
    y = Yeast.new( "My Yeast" )
    y.set_name( nil )
    
    assert_equal( "", y.name )
    assert_equal( 75, y.percent_attenuation )
  end

  def test_set_attenuation_good_1
    # Tests passing negative int
    y = Yeast.new( "My Yeast", 75 )
    y.set_attenuation( -55 )

    assert_equal( "My Yeast", y.name )
    assert_equal( 55, y.percent_attenuation )
  end

  def test_set_attenuation_good_2
    # Tests passing negative int
    y = Yeast.new( "My Yeast", 75 )
    y.set_attenuation( 73.2 )

    assert_equal( "My Yeast", y.name )
    assert_equal( 73.2, y.percent_attenuation )
  end
  
end

