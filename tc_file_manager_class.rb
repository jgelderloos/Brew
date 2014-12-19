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
#   Class: TestFileManager
#
#   Description:
#   Unit tests for the FileManager class

require "test/unit"

require_relative "FileManager"

class TestFileManager < Test::Unit::TestCase
    
  # Testing basic read and write of brew file ------------------------
  
 def test_file_manager_read_write_1
    b = Brew.new( "Wheat Beer" )
    b.volume_final = Water.new( 5, "gal" )
    b.min_boil_time = 60
    g = Grain.new( "wheat", 11, "lbs", 22, 70 )
    g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
    b.add_grain(g)
    b.add_grain(g2)
    h = Hops.new( "chinook", 6.4, 4, 1, "oz" )
    h2 = Hops.new( "cascade", 5.2, 3, 1, "oz" )
    b.add_hops(h)
    b.add_hops(h2)
    b.yeast = Yeast.new( "My Yeast", 75 )
    b.ratio_mash = 1.5
    b.ratio_mash_loss = 0.5
    b.volume_trub_loss = Water.new( 0.25, "gal" )
    b.volume_mash_dead_loss = Water.new( 0.125, "gal" )
    b.rate_boil_off = 1
    b.percent_shrinkage = 4
    
    fm = FileManager.new
    
    fm.save_brew(b)
    
    b2 = fm.read_brew(b.name)
    
    assert_equal( b2.name, "Wheat Beer" )
    assert_equal( b2.volume_final.unit, "gal" )
    assert_equal( b2.volume_final.volume, 5 )
    assert_equal( b2.min_boil_time, 60 )
    assert_equal( b2.grains[0].type, "wheat" )
    assert_equal( b2.grains[0].unit, "lbs" )
    assert_equal( b2.grains[0].mass, 11 )
    assert_equal( b2.grains[0].ppg_potential, 22 )
    assert_equal( b2.grains[0].percent_efficiency, 70 )
    assert_equal( b2.grains[1].type, "barley" )
    assert_equal( b2.grains[1].unit, "lbs" )
    assert_equal( b2.grains[1].mass, 3 )
    assert_equal( b2.grains[1].ppg_potential, 30 )
    assert_equal( b2.grains[1].percent_efficiency, 65 )
    assert_equal( b2.hops[0].type, "chinook" )
    assert_equal( b2.hops[0].alpha, 6.4 )
    assert_equal( b2.hops[0].beta, 4 )
    assert_equal( b2.hops[0].unit, "oz" )
    assert_equal( b2.hops[0].mass, 1 )
    assert_equal( b2.hops[1].type, "cascade" )
    assert_equal( b2.hops[1].alpha, 5.2 )
    assert_equal( b2.hops[1].beta, 3 )
    assert_equal( b2.hops[1].unit, "oz" )
    assert_equal( b2.hops[1].mass, 1 )
    assert_equal( b2.yeast.name, "My Yeast" )
    assert_equal( b2.yeast.percent_attenuation, 75 )
    assert_equal( b2.ratio_mash, 1.5 )
    assert_equal( b2.ratio_mash_loss, 0.5 )
    assert_equal( b2.volume_trub_loss.unit, "gal" )
    assert_equal( b2.volume_trub_loss.volume, 0.25 )
    assert_equal( b2.volume_mash_dead_loss.unit, "gal" )
    assert_equal( b2.volume_mash_dead_loss.volume, 0.125 )
    assert_equal( b2.rate_boil_off, 1 )
    assert_equal( b2.percent_shrinkage, 4 )
  end

  def test_file_manager_hop_data_1
      # test that we can read the default hop data
      fm = FileManager.new

      h = fm.read_data( "hopdata.ini" )

      assert h.is_a? Hash
      assert_equal( h["amarillo"], [8.2, 6.2] )
      assert_equal( h["cascade"], [7.1, 3.2] )
      assert_equal( h["chinook"], [5.6, 10] )
      assert_equal( h["east kent golding"], [3, 4.3] )
      assert_equal( h["simcoe"], [12.7, 4] )
      assert_equal( h["warrior"], [15.7, 6.2] )
  end
  
  def test_file_manager_grain_data_1
      # test that we can read the default grain data
      fm = FileManager.new

      h = fm.read_data( "graindata.ini" )

      assert h.is_a? Hash
      assert_equal( h["2 row"], [45, 70] )
      assert_equal( h["barley"], [45, 70] )
      assert_equal( h["british 2 row"], [37, 75] )
      assert_equal( h["british amber"], [35, 75] )
      assert_equal( h["crystal malt"], [34, 75] )
      assert_equal( h["vienna"], [45, 70] )
      assert_equal( h["wheat"], [45, 70] )
  end
  
end

