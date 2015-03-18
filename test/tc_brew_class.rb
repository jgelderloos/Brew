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
#   Class: TestBrew
#
#   Description:
#   Unit tests for the Brew class

require "test/unit"

require_relative "../lib/Brew"

class TestBrew < Test::Unit::TestCase

  # TODO: add tests that set volumes to different units and assert
  # the calculations still work
    
  # Testing inits -----------------------------------

  def test_init_good_1
    # Test passing nothing
    b = Brew.new()

    assert_equal( "", b.name )
    assert_equal( [], b.grains )
    assert_equal( [], b.hops )
    assert_equal( nil, b.yeast )
    assert_equal( 0, b.lbs_grain_total )
    assert_equal( 0, b.volume_mash.volume )
    assert_equal( 1.5, b.ratio_mash )
    assert_equal( 0, b.volume_mash_loss.volume )
    assert_equal( 0.5, b.ratio_mash_loss )
    assert_equal( 0, b.volume_mash_dead_loss.volume )
    assert_equal( 0, b.volume_sparge.volume )
    assert_equal( 0, b.volume_preboil.volume )
    assert_equal( 1.0, b.rate_boil_off )
    assert_equal( 0, b.volume_boil_loss.volume )
    assert_equal( 0, b.min_boil_time )
    assert_equal( 0, b.volume_trub_loss.volume )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
    assert_equal( 4, b.percent_shrinkage )
    assert_equal( 0, b.volume_final.volume )
    assert_equal( 1, b.gravity_original )
    assert_equal( 1, b.gravity_final )
    assert_equal( 0, b.percent_abv )
    assert_equal( 0, b.ibu )
  end

  def test_init_good_2
    # Test passing name
    b = Brew.new("My Brew")

    assert_equal( "My Brew", b.name )
    assert_equal( [], b.grains )
    assert_equal( [], b.hops )
    assert_equal( nil, b.yeast )
    assert_equal( 0, b.lbs_grain_total )
    assert_equal( 0, b.volume_mash.volume )
    assert_equal( 1.5, b.ratio_mash )
    assert_equal( 0, b.volume_mash_loss.volume )
    assert_equal( 0.5, b.ratio_mash_loss )
    assert_equal( 0, b.volume_mash_dead_loss.volume )
    assert_equal( 0, b.volume_sparge.volume )
    assert_equal( 0, b.volume_preboil.volume )
    assert_equal( 1.0, b.rate_boil_off )
    assert_equal( 0, b.volume_boil_loss.volume )
    assert_equal( 0, b.min_boil_time )
    assert_equal( 0, b.volume_trub_loss.volume )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
    assert_equal( 4, b.percent_shrinkage )
    assert_equal( 0, b.volume_final.volume )
    assert_equal( 1, b.gravity_original )
    assert_equal( 1, b.gravity_final )
    assert_equal( 0, b.percent_abv )
    assert_equal( 0, b.ibu )
  end

  def test_init_good_3
    # Test passing nil
    b = Brew.new(nil)

    assert_equal( "", b.name )
    assert_equal( [], b.grains )
    assert_equal( [], b.hops )
    assert_equal( nil, b.yeast )
    assert_equal( 0, b.lbs_grain_total )
    assert_equal( 0, b.volume_mash.volume )
    assert_equal( 1.5, b.ratio_mash )
    assert_equal( 0, b.volume_mash_loss.volume )
    assert_equal( 0.5, b.ratio_mash_loss )
    assert_equal( 0, b.volume_mash_dead_loss.volume )
    assert_equal( 0, b.volume_sparge.volume )
    assert_equal( 0, b.volume_preboil.volume )
    assert_equal( 1.0, b.rate_boil_off )
    assert_equal( 0, b.volume_boil_loss.volume )
    assert_equal( 0, b.min_boil_time )
    assert_equal( 0, b.volume_trub_loss.volume )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
    assert_equal( 4, b.percent_shrinkage )
    assert_equal( 0, b.volume_final.volume )
    assert_equal( 1, b.gravity_original )
    assert_equal( 1, b.gravity_final )
    assert_equal( 0, b.percent_abv )
    assert_equal( 0, b.ibu )
  end

  # Testing adding grains --------------------------------------
  
  def test_add_grain_bad_1
    # Tests passing nil
    b = Brew.new("Brew")
    b.add_grain(nil)

    assert_equal( [], b.grains )
  end

  def test_add_grain_bad_2
    # Tests passing int
    b = Brew.new("Brew")
    b.add_grain(13)

    assert_equal( [], b.grains )
  end

  def test_add_grain_bad_3
    # Tests passing string
    b = Brew.new("Brew")
    b.add_grain("test")

    assert_equal( [], b.grains )
  end

  def test_add_grain_bad_4
    # Tests passing hop
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    b.add_grain(h)

    assert_equal( [], b.grains )
  end

  def test_add_grain_bad_5
    # Tests passing 2 grains of the same type
    b = Brew.new("Brew")
    g = Grain.new("Wheat")
    g2 = Grain.new("Wheat")
    b.add_grain(g)
    b.add_grain(g2)

    assert_equal( [g], b.grains )
  end

  def test_add_grain_good_1
    # Tests passing grain
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    b.add_grain(g)

    assert_equal( [g], b.grains )
  end

  def test_add_grain_good_2
    # Tests adding 2 grains
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    b.add_grain(g)
    b.add_grain(g2)

    assert_equal( [g,g2], b.grains )
  end

  # Testing removing grains -------------------------------
  
  def test_remove_grain_bad_1
    # Tests passing nil
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain(nil)
    assert_equal( [g], b.grains )
  end

  def test_remove_grain_bad_2
    # Tests passing hop
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    h = Hops.new("chinook")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain(h)
    assert_equal( [g], b.grains )
  end

  def test_remove_grain_bad_3
    # Tests passing int
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain(2)
    assert_equal( [g], b.grains )
  end

  def test_remove_grain_good_1
    # Tests basic remove
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain(g)
    assert_equal( [], b.grains )
  end

  def test_remove_grain_good_2
    # Tests remove last grain
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain(g3)
    assert_equal( [g, g2], b.grains )
  end

  def test_remove_grain_good_3
    # Tests remove middle grain
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain(g2)
    assert_equal( [g, g3], b.grains )
  end

  def test_remove_grain_good_4
    # Tests remove first grain
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain(g)
    assert_equal( [g2, g3], b.grains )
  end

  # Testing remove_grain_at -------------------------

  def test_remove_grain_at_bad_1
    # Tests out of range 
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain_at(-2)
    assert_equal( [g], b.grains )
  end

  def test_remove_grain_at_bad_2
    # Tests out of range 
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain_at(2)
    assert_equal( [g], b.grains )
  end

  def test_remove_grain_at_bad_3
    # Tests passing niol 
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    assert_raise TypeError do
      b.remove_grain_at(nil)
    end
  end

  def test_remove_grain_at_good_1
    # Tests basic remove
    b = Brew.new("Brew")
    g = Grain.new("wheat")

    b.add_grain(g)
    assert_equal( [g], b.grains )

    b.remove_grain_at(0)
    assert_equal( [], b.grains )
  end

  def test_remove_grain_at_good_2
    # Tests remove from last
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain_at(2)
    assert_equal( [g, g2], b.grains )
  end

  def test_remove_grain_at_good_3
    # Tests remove from middle
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain_at(1)
    assert_equal( [g, g3], b.grains )
  end

  def test_remove_grain_at_good_4
    # Tests remove from first
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain_at(0)
    assert_equal( [g2, g3], b.grains )
  end

  def test_remove_grain_at_good_5
    # Tests remove with negative
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    g2 = Grain.new("barley")
    g3 = Grain.new("vienna")

    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    assert_equal( [g, g2, g3], b.grains )

    b.remove_grain_at(-2)
    assert_equal( [g, g3], b.grains )
  end

  # Testing has_grain? --------------------------------------

  def test_has_grain_bad_1
    # Test check for nil
    b = Brew.new("Brew")

    assert_equal( false, b.has_grain?(nil) )

    g = Grain.new("Wheat")
    b.add_grain(g)

    assert_raise NoMethodError do 
      b.has_grain?(nil)
    end

  end  

  def test_has_grain_good_1
    # Test checking for non-existing grain
    b = Brew.new("Brew")
    g = Grain.new("Wheat")
    b.add_grain(g)

    assert_equal( false, b.has_grain?( "Barley" ) )
  end

  def test_has_grain_good_2
    # Test checking for existing grain
    b = Brew.new("Brew")
    g = Grain.new("Barley")
    g2 = Grain.new("Wheat")
    b.add_grain(g)
    b.add_grain(g2)

    assert_equal( true, b.has_grain?( "wheat" ) )
  end

  # Testing updating grain -----------------------------------

  def test_update_grain_bad_1
    # Tests passing nil
    b = Brew.new("Brew")
    
    assert_raise NoMethodError do
      b.update_grain(nil)
    end

    assert_raise NoMethodError do
      b.update_grain("Wheat")
    end
  end

  def test_update_grain_good_1
    # Basic update of a grain
    b = Brew.new("Brew")

    g = Grain.new("Wheat", 12, "lbs", 30, 75)
    b.add_grain(g)

    g2 = Grain.new("wheat", 14, "lbs", 35, 70)
    b.update_grain(g2)

    assert_equal( [g2], b.grains )
  end

  def test_update_grain_good_2
    # Test updating from default values
    b = Brew.new("Brew")

    g = Grain.new("Wheat")
    b.add_grain(g)

    g2 = Grain.new("wheat", 40, "kg", 20, 90)
    b.update_grain(g2)

    assert_equal( [g2], b.grains )
  end
  
  def test_update_grain_good_3
    # Test updating a non existing grain
    b = Brew.new("Brew")

    g = Grain.new("wheat", 12, "lbs", 20, 90)
    b.update_grain(g)

    assert_equal( [g], b.grains )
  end

  # Testing adding hops --------------------------------------
  
  def test_add_hops_bad_1
    # Tests passing nil
    b = Brew.new("Brew")
    b.add_hops(nil)

    assert_equal( [], b.hops )
  end

  def test_add_hops_bad_2
    # Tests passing int
    b = Brew.new("Brew")
    b.add_hops(13)

    assert_equal( [], b.hops )
  end

  def test_add_hops_bad_3
    # Tests passing string
    b = Brew.new("Brew")
    b.add_hops("test")

    assert_equal( [], b.hops )
  end

  def test_add_hops_bad_4
    # Tests passing grain
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    b.add_hops(g)

    assert_equal( [], b.hops )
  end

  def test_add_hops_bad_5
    # Tests passing 2 hops of the same type
    b = Brew.new("Brew")
    h = Hops.new("Simcoe")
    h2 = Hops.new("Simcoe")
    b.add_hops(h)
    b.add_hops(h2)

    assert_equal( [h], b.hops )
  end
  
  def test_add_hops_good_1
    # Tests passing hops
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    b.add_hops(h)

    assert_equal( [h], b.hops )
  end

  def test_add_hops_good_2
    # Tests adding 2 hops
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("simcoe")
    b.add_hops(h)
    b.add_hops(h2)

    assert_equal( [h,h2], b.hops )
  end

  # Testing removing hops -------------------------------
  
  def test_remove_hops_bad_1
    # Tests passing nil
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops(nil)
    assert_equal( [h], b.hops )
  end

  def test_remove_hops_bad_2
    # Tests passing grain
    b = Brew.new("Brew")
    g = Grain.new("wheat")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops(g)
    assert_equal( [h], b.hops )
  end

  def test_remove_hops_bad_3
    # Tests passing int
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops(2)
    assert_equal( [h], b.hops )
  end

  def test_remove_hops_good_1
    # Tests basic remove
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops(h)
    assert_equal( [], b.hops )
  end

  def test_remove_hops_good_2
    # Tests remove last grain
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops(h3)
    assert_equal( [h, h2], b.hops )
  end

  def test_remove_hops_good_3
    # Tests remove middle grain
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops(h2)
    assert_equal( [h, h3], b.hops )
  end

  def test_remove_hops_good_4
    # Tests remove first grain
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops(h)
    assert_equal( [h2, h3], b.hops )
  end

  # Testing remove_hops_at -------------------------

  def test_remove_hops_at_bad_1
    # Tests out of range 
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops_at(-2)
    assert_equal( [h], b.hops )
  end

  def test_remove_hops_at_bad_2
    # Tests out of range 
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops_at(2)
    assert_equal( [h], b.hops )
  end

  def test_remove_hops_at_bad_3
    # Tests passing niol 
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    assert_raise TypeError do
    b.remove_hops_at(nil)
    end
  end

  def test_remove_hops_at_good_1
    # Tests basic remove
    b = Brew.new("Brew")
    h = Hops.new("chinook")

    b.add_hops(h)
    assert_equal( [h], b.hops )

    b.remove_hops_at(0)
    assert_equal( [], b.hops )
  end

  def test_remove_hops_at_good_2
    # Tests remove from last
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops_at(2)
    assert_equal( [h, h2], b.hops )
  end

  def test_remove_hops_at_good_3
    # Tests remove from middle
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops_at(1)
    assert_equal( [h, h3], b.hops )
  end

  def test_remove_hops_at_good_4
    # Tests remove from first
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops_at(0)
    assert_equal( [h2, h3], b.hops )
  end

  def test_remove_hops_at_good_5
    # Tests remove with negative
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    h2 = Hops.new("warrior")
    h3 = Hops.new("simcoe")

    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)
    assert_equal( [h, h2, h3], b.hops )

    b.remove_hops_at(-2)
    assert_equal( [h, h3], b.hops )
  end
  
  # Testing has_hops? --------------------------------------

  def test_has_hops_bad_1
    # Test check for nil

    b = Brew.new("Brew")

    assert_equal( false, b.has_hops?(nil) )

    h = Hops.new("Simcoe")
    b.add_hops(h)

    assert_raise NoMethodError do
      b.has_hops?(nil)
    end

  end  

  def test_has_hops_good_1
    # Test checking for non-existing hops
    b = Brew.new("Brew")
    h = Hops.new("Simcoe")
    b.add_hops(h)

    assert_equal( false, b.has_hops?( "Warrior" ) )
  end

  def test_has_hops_good_2
    # Test checking for existing hops
    b = Brew.new("Brew")
    h = Hops.new("Simcoe")
    h2 = Hops.new("Warrior")
    b.add_hops(h)
    b.add_hops(h2)

    assert_equal( true, b.has_hops?( "Simcoe" ) )
  end

  # Testing updating hops -----------------------------------

  def test_update_hops_bad_1
    # Tests passing nil
    b = Brew.new("Brew")
    
    assert_raise NoMethodError do
      b.update_hops(nil)
    end

    assert_raise NoMethodError do
      b.update_hops("Simcoe")
    end
  end

  def test_update_hops_good_1
    # Basic update of a hop
    b = Brew.new("Brew")

    h = Hops.new("Simcoe", 3.5, 4.5, 3, "oz")
    b.add_hops(h)

    h2 = Hops.new("Simcoe", 3, 4, 1, "oz")
    b.update_hops(h2)

    assert_equal( [h2], b.hops )
  end

  def test_update_hops_good_2
    # Test updating from default values
    b = Brew.new("Brew")

    h = Hops.new("Simcoe")
    b.add_hops(h)

    h2 = Hops.new("Simcoe", 3.5, 4.5, 2, "oz")
    b.update_hops(h2)

    assert_equal( [h2], b.hops )
  end
  
  def test_update_hops_good_3
    # Test updating a non existing hop
    b = Brew.new("Brew")

    h = Hops.new("Simcoe", 1.2, 3, 2, "oz")
    b.update_hops(h)

    assert_equal( [h], b.hops )
  end

  # Testing total_grain_mass? ---------------------------

  def test_total_grain_mass_good_1
    # Tests no grains
    b = Brew.new("Brew")

    assert_equal( 0, b.total_grain_mass? )
  end

  def test_total_grain_mass_good_2
    # Tests one grain
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    b.add_grain(g)
  
    assert_equal( 12.5, b.total_grain_mass? )
  end

  def test_total_grain_mass_good_3
    # Tests multiple grains
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)

    assert_equal( 13, b.total_grain_mass? )
  end

  # Testing calc_volume_mash -------------------------------

  def test_calc_volume_mash_bad_1
    # Tests nil ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash = nil

    assert_raise NoMethodError do
      b.calc_volume_mash
    end
  end

  def test_calc_volume_mash_bad_2
    # Tests string ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash = "one"

    assert_raise NoMethodError do
      b.calc_volume_mash
    end
  end

  def test_calc_volume_mash_good_1
    # Tests multiple grains
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
  
    assert_equal( 4.875, b.calc_volume_mash )
    assert_equal( 0, b.volume_mash.volume )
  end

  def test_calc_volume_mash_good_2
    # Tests multiple grains
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.75 )
    g2 = Grain.new("barley", 0 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
  
    assert_equal( 4.875, b.calc_volume_mash )
    assert_equal( 0, b.volume_mash.volume )
  end

  def test_calc_volume_mash_good_3
    # Tests changing the ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash = 2
  
    assert_equal( 6.5, b.calc_volume_mash )
    assert_equal( 0, b.volume_mash.volume )
  end

  def test_calc_volume_mash_good_4
    # Tests negative ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash = -1.5
  
    assert_equal( 4.875, b.calc_volume_mash )
    assert_equal( 0, b.volume_mash.volume )
  end

  def test_bang_calc_volume_mash_good_1
    # Tests ! version chagnes brew
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.calc_volume_mash!
  
    assert_equal( 4.875, b.volume_mash.volume )
    assert_equal( "gal", b.volume_mash.unit )
  end

  # Testing calc_volume_mash_loss -------------------------------

  def test_calc_volume_mash_loss_bad_1
    # Tests nil ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash_loss = nil
  
    assert_raise NoMethodError do
      b.calc_volume_mash_loss
    end
  end

  def test_calc_volume_mash_loss_bad_2
    # Tests string ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash_loss = "two"
  
    assert_raise NoMethodError do
      b.calc_volume_mash_loss
    end
  end

  def test_calc_volume_mash_loss_good_1
    # Tests multiple grains
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
  
    assert_equal( 1.625, b.calc_volume_mash_loss )
    assert_equal( 0, b.volume_mash_loss.volume )
  end

  def test_calc_volume_mash_loss_good_2
    # Tests multiple grains
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.75 )
    g2 = Grain.new("barley", 0 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
  
    assert_equal( 1.625, b.calc_volume_mash_loss )
    assert_equal( 0, b.volume_mash_loss.volume )
  end

  def test_calc_volume_mash_loss_good_3
    # Tests changing the ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash_loss = 1 
  
    assert_equal( 3.25, b.calc_volume_mash_loss )
    assert_equal( 0, b.volume_mash_loss.volume )
  end

  def test_calc_volume_mash_loss_good_4
    # Tests negative ratio
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.ratio_mash_loss = -0.5
  
    assert_equal( 1.625, b.calc_volume_mash_loss )
    assert_equal( 0, b.volume_mash_loss.volume )
  end

  def test_bang_calc_volume_mash_loss_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    g = Grain.new("wheat", 12.5 )
    g2 = Grain.new("barley", 0.25 )
    g3 = Grain.new("vienna", 0.25 )
    b.add_grain(g)
    b.add_grain(g2)
    b.add_grain(g3)
    b.calc_volume_mash_loss!
  
    assert_equal( 1.625, b.volume_mash_loss.volume )
    assert_equal( "gal", b.volume_mash_loss.unit )
  end

  # Testing calc_volume_boil_loss ---------------------------------

   def test_calc_volume_boil_loss_bad_1
    # Tests nil time
    b = Brew.new("Brew")
    b.min_boil_time = nil
    
    assert_raise NoMethodError do
      b.calc_volume_boil_loss
    end
  end

  def test_calc_volume_boil_loss_bad_2
    # Tests string time
    b = Brew.new("Brew")
    b.min_boil_time = "sixty"
    
    assert_raise NoMethodError do
      b.calc_volume_boil_loss
    end
  end

  def test_calc_volume_boil_loss_bad_3
    # Tests nil rate
    b = Brew.new("Brew")
    b.rate_boil_off = nil
    
    assert_raise TypeError do
      b.calc_volume_boil_loss
    end
  end

  def test_calc_volume_boil_loss_bad_4
    # Tests string rate
    b = Brew.new("Brew")
    b.rate_boil_off = "five"
    
    assert_raise TypeError do
      b.calc_volume_boil_loss
    end
  end

  def test_calc_volume_boil_loss_good_1
    # Tests 0 min
    b = Brew.new("Brew")
    b.min_boil_time = 0
    b.rate_boil_off = 1

    assert_equal( 0, b.calc_volume_boil_loss )
    assert_equal( 0, b.volume_boil_loss.volume )
  end

  def test_calc_volume_boil_loss_good_2
    # Tests 60 min
    b = Brew.new("Brew")
    b.min_boil_time = 60
    b.rate_boil_off = 1
    
    assert_equal( 1, b.calc_volume_boil_loss )
    assert_equal( 0, b.volume_boil_loss.volume )
  end

  def test_calc_volume_boil_loss_good_3
    # Tests 60 min
    b = Brew.new("Brew")
    b.min_boil_time = 60
    b.rate_boil_off = 1.5
    
    assert_equal( 1.5, b.calc_volume_boil_loss )
    assert_equal( 0, b.volume_boil_loss.volume )
  end

  def test_bang_calc_volume_boil_loss_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    b.min_boil_time = 60
    b.rate_boil_off = 1
    b.calc_volume_boil_loss!
    
    assert_equal( 1, b.volume_boil_loss.volume )
    assert_equal( "gal", b.volume_boil_loss.unit )
  end

  # Testing calc_volume_shrinkage_loss

  def test_calc_volume_shrinkage_loss_bad_1
    # Tests nil shrink factor
    b = Brew.new("Brew")
    b.percent_shrinkage = nil
    
    assert_raise TypeError do
      b.calc_volume_shrinkage_loss
    end
  end

  def test_calc_volume_shrinkage_loss_bad_2
    # Tests string shrink factor
    b = Brew.new("Brew")
    b.percent_shrinkage = "five"
    
    assert_raise TypeError do
      b.calc_volume_shrinkage_loss
    end
  end

  def test_calc_volume_shrinkage_loss_good_1
    # Tests no volumes set
    b = Brew.new("Brew")
    
    assert_equal( 0, b.calc_volume_shrinkage_loss )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
  end

  def test_calc_volume_shrinkage_loss_good_2
    # Tests final volume set
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    
    assert_equal( 0.20833333333333393, b.calc_volume_shrinkage_loss )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
  end

  def test_calc_volume_shrinkage_loss_good_3
    # Tests trub loss set
    b = Brew.new("Brew")
    b.volume_trub_loss.volume = 5
    
    assert_equal( 0.20833333333333393, b.calc_volume_shrinkage_loss )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
  end

  def test_calc_volume_shrinkage_loss_good_4
    # Tests both final and trub set
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 0.5
    
    assert_equal( 0.22916666666666696, b.calc_volume_shrinkage_loss )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
  end

  def test_calc_volume_shrinkage_loss_good_5
    # Tests change the shrink percentage
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 0.5
    b.percent_shrinkage = 8
    
    assert_equal( 0.47826086956521685, b.calc_volume_shrinkage_loss )
    assert_equal( 0, b.volume_shrinkage_loss.volume )
  end

  def test_bang_calc_volume_shrinkage_loss_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 0.5
    b.calc_volume_shrinkage_loss!
    
    assert_equal( 0.22916666666666696, b.volume_shrinkage_loss.volume )
    assert_equal( "gal", b.volume_shrinkage_loss.unit )
  end

  # Testing calc_volume_preboil -------------------------------------------

  def test_calc_volume_preboil_good_1
    # Tests with all volumes 0
    b = Brew.new("Brew")
    
    assert_equal( 0, b.calc_volume_preboil )
    assert_equal( 0, b.volume_preboil.volume )
  end

  def test_calc_volume_preboil_good_2
    # Tests with volume final
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    
    assert_equal( 5, b.calc_volume_preboil )
    assert_equal( 0, b.volume_preboil.volume )
  end

  def test_calc_volume_preboil_good_3
    # Tests with trub loss
    b = Brew.new("Brew")
    b.volume_trub_loss.volume = 2
    
    assert_equal( 2, b.calc_volume_preboil )
    assert_equal( 0, b.volume_preboil.volume )
  end

  def test_calc_volume_preboil_good_4
    # Tests with shrinkage loss
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    b.calc_volume_shrinkage_loss!
    b.volume_final.volume = 0
    
    assert_equal( 0.20833333333333393, b.calc_volume_preboil )
    assert_equal( 0, b.volume_preboil.volume )
  end  

  def test_calc_volume_preboil_good_5
    # Tests with boil loss
    b = Brew.new("Brew")
    b.min_boil_time = 60
    b.calc_volume_boil_loss!
    
    assert_equal( 1, b.calc_volume_preboil )
    assert_equal( 0, b.volume_preboil.volume )
  end

  def test_bang_calc_volume_preboil_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 0.25
    b.min_boil_time = 60
    b.calc_volume_shrinkage_loss!
    b.calc_volume_boil_loss!
    b.calc_volume_preboil!
    
    assert_equal( 6.46875, b.volume_preboil.volume )
    assert_equal( "gal", b.volume_preboil.unit )
  end

  # Testing calc_volume_sparge ---------------------------------

  def test_calc_volume_sparge_good_1
    # Tests with all volumes 0
    b = Brew.new("Brew")

    assert_equal( 0, b.calc_volume_sparge )
    assert_equal( 0, b.volume_sparge.volume )
  end

  def test_calc_volume_sparge_good_2
    # Tests with preboil volume
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 0.25
    b.calc_volume_shrinkage_loss!
    b.calc_volume_boil_loss!
    b.calc_volume_preboil!

    assert_equal( 5.46875, b.calc_volume_sparge )
    assert_equal( 0, b.volume_sparge.volume )
  end

  def test_calc_volume_sparge_good_3
    # Tests with mash volume
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13)
    b.add_grain(g)
    b.calc_volume_mash!

    assert_equal( -4.875, b.calc_volume_sparge )
    assert_equal( 0, b.volume_sparge.volume )
  end

  def test_calc_volume_sparge_good_4
    # Tests with mash loss volume
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13)
    b.add_grain(g)
    b.calc_volume_mash_loss!

    assert_equal( 1.625, b.calc_volume_sparge )
    assert_equal( 0, b.volume_sparge.volume )
  end

  def test_bang_calc_volume_sparge_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13)
    b.add_grain(g)
    b.calc_volume_mash!
    b.calc_volume_mash_loss!
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 0.25
    b.calc_volume_shrinkage_loss!
    b.calc_volume_boil_loss!
    b.calc_volume_preboil!
    b.calc_volume_sparge!

    assert_equal( 2.21875, b.volume_sparge.volume )
    assert_equal( "gal", b.volume_sparge.unit )
  end

  # Testing calc_gravity_original ---------------------------------

  def test_calc_gravity_original_good_1
    # Tests all inputs at 0
    b = Brew.new("Brew")
    
    assert_equal( 1, b.calc_gravity_original )
    assert_equal( 1, b.gravity_original )
  end

  def test_calc_gravity_original_good_2
    # Tests with final volume
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    
    assert_equal( 1, b.calc_gravity_original )
    assert_equal( 1, b.gravity_original )
  end

  def test_calc_gravity_original_good_3
    # Tests with trub loss
    b = Brew.new("Brew")
    b.volume_trub_loss.volume = 2
    
    assert_equal( 1, b.calc_gravity_original )
    assert_equal( 1, b.gravity_original )
  end

  def test_calc_gravity_original_good_4
    # Tests with grain ppg
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 45, 0 )
    b.add_grain(g)

    assert( b.calc_gravity_original.nan? )
    assert_equal( 1, b.gravity_original )
  end

  def test_calc_gravity_original_good_5
    # Tests with grain efficiency
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 0, 75 )
    b.add_grain(g)
    
    assert( b.calc_gravity_original.nan? )
    assert_equal( 1, b.gravity_original )
  end

  def test_calc_gravity_original_good_6
    # Tests with all needed values
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    
    assert_equal( 1.073125, b.calc_gravity_original )
    assert_equal( 1, b.gravity_original )
  end 

  def test_bang_calc_gravity_original_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!
    
    assert_equal( 1.073125, b.gravity_original )
  end

  # Testing calc_gravity_final --------------------------------

  def test_calc_gravity_final_good_1
    # Tests with all values at 0
    b = Brew.new("Brew")
    y = Yeast.new( "Yeast", 75 )
    b.yeast = y

    assert_equal( 1, b.calc_gravity_final )
    assert_equal( 1, b.gravity_final )
  end

  def test_calc_gravity_final_good_2
    # Tests with original gravity
    b = Brew.new("Brew")
    y = Yeast.new( "Yeast", 75 )
    b.yeast = y
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!

    assert_equal( 1.01828125, b.calc_gravity_final )
    assert_equal( 1, b.gravity_final )
  end

  def test_calc_gravity_final_good_3
    # Tests with different yeast value
    b = Brew.new("Brew")
    y = Yeast.new( "Yeast", 75 )
    b.yeast = y
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!
    b.yeast = Yeast.new("Yeast", 95)
    
    assert_equal( 1.00365625, b.calc_gravity_final )
    assert_equal( 1, b.gravity_final )
  end

  def test_bang_calc_gravity_final_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    y = Yeast.new( "Yeast", 75 )
    b.yeast = y
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!
    b.yeast = Yeast.new("Yeast", 95)
    b.calc_gravity_final!
    
    assert_equal( 1.00365625, b.gravity_final )
  end

  # Testing calc_percent_abv ----------------------------------

  def test_calc_percent_abv_good_1
    # Tests with all values at 0
    b = Brew.new("Brew")

    assert_equal( 0, b.calc_percent_abv )
    assert_equal( 0, b.percent_abv )
  end

  def test_calc_percent_abv_good_2
    # Tests with original gravity
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!

    assert_equal( 9.719145569620267, b.calc_percent_abv )
    assert_equal( 0, b.percent_abv )
  end

  def test_calc_percent_abv_good_3
    # Tests with final and original gravity
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!
    b.yeast = Yeast.new("Yeast", 95)
    b.calc_gravity_final!

    assert_equal( 9.199552427575941, b.calc_percent_abv )
    assert_equal( 0, b.percent_abv )
  end

  def test_bang_calc_percent_abv_good_1
    # Tests ! version changes brew
    b = Brew.new("Brew")
    g = Grain.new("wheat", 13, "lbs", 45, 75 )
    b.add_grain(g)
    b.volume_final.volume = 5
    b.volume_trub_loss.volume = 1
    b.calc_gravity_original!
    b.yeast = Yeast.new("Yeast", 95)
    b.calc_gravity_final!
    b.calc_percent_abv!

    assert_equal( 9.199552427575941, b.percent_abv )
  end

  # Testing total_hops_mass? ---------------------------

  def test_total_hops_mass_good_1
    # Tests no hops
    b = Brew.new("Brew")

    assert_equal( 0, b.total_hops_mass? )
  end

  def test_total_hops_mass_good_2
    # Tests one hop
    b = Brew.new("Brew")
    h = Hops.new("chinook", 4, 4, 1, "oz" )
    b.add_hops(h)
  
    assert_equal( 1, b.total_hops_mass? )
  end

  def test_total_hops_mass_good_3
    # Tests multiple hops
    b = Brew.new("Brew")
    h = Hops.new("chinook", 4, 4, 1, "oz" )
    h2 = Hops.new("warrior", 4, 4, 0.25, "oz" )
    h3 = Hops.new("simcoe", 4, 4, 0.25, "oz" )
    b.add_hops(h)
    b.add_hops(h2)
    b.add_hops(h3)

    assert_equal( 1.5, b.total_hops_mass? )
  end

  # Testing calc_ibu -----------------------------------------

  def test_calc_ibu_good_1
    # Tests with no values
    b = Brew.new("Brew")

    assert_equal( 0, b.calc_ibu )
  end

  def test_calc_ibu_good_2
    # Tests with 1 hop
    b = Brew.new("Brew")
    h = Hops.new("chinook")
    b.add_hops(h)

    assert( b.calc_ibu.nan? )
  end

  def test_calc_ibu_good_3
    # Tests with final volume
    b = Brew.new("Brew")
    b.volume_final.volume = 5

    assert_equal( 0, b.calc_ibu )
  end

  def test_calc_ibu_good_4
    # Tests with all needed values
    b = Brew.new("Brew")
    b.volume_final.volume = 5
    h = Hops.new("chinook", 5.6, 10, 1, "oz" )
    b.add_hops(h)

    assert_equal( 25.168539325842694, b.calc_ibu )
  end
end

