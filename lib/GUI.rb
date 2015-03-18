#   Copyright 2015 jgelderloos
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
#   Class: GUI
#
#   Description:
#   Creates and handles events of the main app window.

require 'rubygems'
require 'Qt'
#require_relative 'Grain'


class BrewApp < Qt::MainWindow
  slots( 'item_clicked(QListWidgetItem*)', 'add_clicked()', 'edit_item()', 'remove_clicked()', 'on_activated(QString)', 'on_name_changed(QString)', 
         'on_mass_changed(QString)', 'on_unit_activated(QString)', 'on_ppg_changed(QString)', 'on_efficiency_changed(QString)', 
         'on_alpha_changed(QString)', 'on_beta_changed(QString)',
         'on_attenuation_changed(QString)', 'on_final_volume_changed(QString)', 'on_mash_ratio_changed(QString)',
         'on_mash_ratio_loss_changed(QString)', 'on_boil_time_changed(QString)', 'on_trub_loss_changed(QString)',
         'on_dead_loss_changed(QString)', 'on_rate_boil_off_changed(QString)', 'on_shrinkage_changed(QString)',
         'brew_save_clicked()', 'brew_cancel_clicked()' )

  def initialize parent = nil
    super( parent )

    init_ui
    
    resize( 600, 400 )
    move( 300, 300 )
    
    show
  end
	
  def set_controller c
    @controller = c
  end

  def init_ui

    # Create tab manager as the main widget
    tab_manager = Qt::TabWidget.new self
    self.central_widget = tab_manager
    
    # Add tabs
    ingredients_tab = Qt::Widget.new self
    tab_manager.addTab( ingredients_tab, "Ingredients" )

    brew_tab = Qt::Widget.new self
    tab_manager.addTab( brew_tab, "Brew" )

    setWindowTitle "Brew App"
	
    # unispaced font so the stext can form nice columns
    @font = Qt::Font.new()
    @font.setFamily("Courier New")
	  
    # Create the ingredients layout
    ingredients_tab.layout = self.create_ingredients
		
    # Create the brew layout
    brew_tab.layout = self.create_brew

  end

  def create_ingredients
    hbox = Qt::HBoxLayout.new
    
    # Create vbox containing scrolls area and ingredient fields
    vbox_left = self.create_left_ingredients

    # Add sub sections to the main layout
    hbox.addLayout( vbox_left )
 
    # creates the buttons for add, delete, edit inside a vbox
    button_vbox = self.create_button_vbox
   
    #hbox.addStretch( 1 )
    hbox.addLayout( button_vbox )

    return hbox
  end

  def create_left_ingredients
    # Creates the scroll area with premade headers
    items_scroll = self.create_scroll_area 

    # Creates the boxes for entering new item information
    self.create_left_boxes 

    # Create vertical box for the left side of the app
    vbox_left = Qt::VBoxLayout.new

    @hbox_mass_unit = Qt::HBoxLayout.new
    @hbox_mass_unit.addWidget( @mass_box )
    @hbox_mass_unit.addWidget( @unit_box )

    vbox_left.addWidget( items_scroll )
    vbox_left.addWidget( @type_combo )
    vbox_left.addWidget( @name_box )
    vbox_left.addLayout( @hbox_mass_unit )
    vbox_left.addWidget( @ppg_box )
    vbox_left.addWidget( @efficiency_box )
    vbox_left.addWidget( @alpha_box )
    vbox_left.addWidget( @beta_box )
    vbox_left.addWidget( @attenuation_box )
    vbox_left.addStretch( 1 )

    return vbox_left
  end

  def create_scroll_area

    # Arrays that hold the strings that will populate the scroll area
    @grain_strings = Array.new
    @hops_strings = Array.new

    # We only have 1 yeast so we only want to add it once
    @yeast_added = false

    # Create scroll area with default headers
    items_scroll = Qt::ScrollArea.new
    items_scroll.setWidgetResizable( true )

    @grain_header = Qt::ListWidgetItem.new( "Grain --------- | Mass -- | Unit - | PPG | Efficiency |" )
    @grain_header.setFont( @font )
    @end_of_grains = 0
    @hops_header = Qt::ListWidgetItem.new( "Hops ---------- | Mass -- | Unit - | Alpha - | Beta -- |" ) 
    @hops_header.setFont( @font )
    @end_of_hops = 1
    @yeast_header = Qt::ListWidgetItem.new( "Yeast --------- | Attenuation |" )
    @yeast_header.setFont( @font )
    @end_of_yeast = 2

    @item_list = Qt::ListWidget.new
    
    @item_list.addItem( @grain_header )
    @item_list.addItem( @hops_header )
    @item_list.addItem( @yeast_header )

    connect( @item_list, SIGNAL( "itemClicked(QListWidgetItem*)"), self, SLOT( "item_clicked(QListWidgetItem*)" ))
    
    items_scroll.setWidget( @item_list )

    return items_scroll
  end

  def create_left_boxes
    @type_combo = Qt::ComboBox.new self
    @type_combo.addItem( "Grain" )
    @type_combo.addItem( "Hops" )
    @type_combo.addItem( "Yeast" )
    connect( @type_combo, SIGNAL( "activated(QString)"), self, SLOT("on_activated(QString)") )
    # Type gets changed on combo activated() but we need to set its default value here
    @type = "grain"

    @name_box = Qt::LineEdit.new self
    connect( @name_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_name_changed(QString)") )
    @name_box.setPlaceholderText( "Enter name" )

    @mass_box = Qt::LineEdit.new self
    connect( @mass_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_mass_changed(QString)") )
    @mass_box.setPlaceholderText( "Enter mass" )
    @unit_box = Qt::ComboBox.new self
    @unit_box.addItem( "lbs" )
    @unit_box.addItem( "Kg" )
    connect( @unit_box, SIGNAL( "activated(QString)" ), self, SLOT("on_unit_activated(QString)") )
    # Unit gets changed on activated() but we need to set its default value here
    @unit = "lbs"
    
    @ppg_box = Qt::LineEdit.new self
    connect( @ppg_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_ppg_changed(QString)") )
    @ppg_box.setPlaceholderText( "Enter ppg" )

    @efficiency_box = Qt::LineEdit.new self
    connect( @efficiency_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_efficiency_changed(QString)") )
    @efficiency_box.setPlaceholderText( "Enter efficency" )

    @alpha_box = Qt::LineEdit.new self
    connect( @alpha_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_alpha_changed(QString)") )
    @alpha_box.setPlaceholderText( "Enter alpha" )
    @alpha_box.hide

    @beta_box = Qt::LineEdit.new self
    connect( @beta_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_beta_changed(QString)") )
    @beta_box.setPlaceholderText( "Enter beta" )
    @beta_box.hide

    @attenuation_box = Qt::LineEdit.new self
    connect( @attenuation_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_attenuation_changed(QString)") )
    @attenuation_box.setPlaceholderText( "Enter attenuation" )
    @attenuation_box.hide
  end

  def create_button_vbox
    # Create buttons and assign signals
    @button_add = Qt::PushButton.new( "Add", self )
    connect( @button_add, SIGNAL( "clicked()" ), SLOT( "add_clicked()" ) )
    
    @button_edit = Qt::PushButton.new( "Edit", self )
    connect( @button_edit, SIGNAL( "clicked()" ), SLOT( "edit_item()" ) )

    @button_remove = Qt::PushButton.new( "Remove", self )
    connect( @button_remove, SIGNAL( "clicked()" ), SLOT( "remove_clicked()" ) )
		
    # Create vertical box for the buttons
    vbox = Qt::VBoxLayout.new
    		
    vbox.addStretch( 1 )
    vbox.addWidget( @button_add )
    vbox.addWidget( @button_edit )
    vbox.addWidget( @button_remove )

    return vbox
  end

  def create_brew
    hbox = Qt::HBoxLayout.new

    # Create left grid that holds values from the brew
    left_grid = self.create_brew_left_grid

    hbox.addLayout( left_grid )

    right_grid = self.create_brew_recipe_grid

    hbox.addLayout( right_grid )

    right_buttons = self.create_brew_button_vbox

    hbox.addLayout( right_buttons )

    return hbox
  end

  def create_brew_left_grid
    grid_brew = Qt::GridLayout.new

    final_volume_label = Qt::Label.new( "Final Volume (gal)", self )
    @final_volume_box = Qt::LineEdit.new self
    connect( @final_volume_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_final_volume_changed(QString)") )

    mash_ratio_label = Qt::Label.new( "Mash Ratio (qts/lb)", self )
    @mash_ratio_box = Qt::LineEdit.new self
    connect( @mash_ratio_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_mash_ratio_changed(QString)") )

    mash_ratio_loss_label = Qt::Label.new( "Mash Loss Ratio (qts/lb)", self )
    @mash_ratio_loss_box = Qt::LineEdit.new self
    connect( @mash_ratio_loss_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_mash_ratio_loss_changed(QString)") )

    boil_time_label = Qt::Label.new( "Boil Time (min)", self )
    @boil_time_box = Qt::LineEdit.new self
    connect( @boil_time_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_boil_time_changed(QString)") )

    trub_loss_label = Qt::Label.new( "Trub Loss (gal)", self )
    @trub_loss_box = Qt::LineEdit.new self
    connect( @trub_loss_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_trub_loss_changed(QString)") )

    dead_loss_label = Qt::Label.new( "Dead Loss (gal)", self )
    @dead_loss_box = Qt::LineEdit.new self
    connect( @dead_loss_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_dead_loss_changed(QString)") )

    rate_boil_off_label = Qt::Label.new( "Rate Boil Off (gal/hr)", self )
    @rate_boil_off_box = Qt::LineEdit.new self
    connect( @rate_boil_off_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_rate_boil_off_changed(QString)") )

    shrinkage_label = Qt::Label.new( "Shrinkage (%)", self )
    @shrinkage_box = Qt::LineEdit.new self
    connect( @shrinkage_box, SIGNAL( "textChanged(QString)" ), self, SLOT("on_shrinkage_changed(QString)") )


    grid_brew.addWidget( final_volume_label, 0, 0 )
    grid_brew.addWidget( @final_volume_box, 0, 1, 1, 3 )
    grid_brew.addWidget( mash_ratio_label, 1, 0 )
    grid_brew.addWidget( @mash_ratio_box, 1, 1, 1, 3 )
    grid_brew.addWidget( mash_ratio_loss_label, 2, 0 )
    grid_brew.addWidget( @mash_ratio_loss_box, 2, 1, 1, 3 )
    grid_brew.addWidget( boil_time_label, 3, 0 )
    grid_brew.addWidget( @boil_time_box, 3, 1, 1, 3 )
    grid_brew.addWidget( trub_loss_label, 4, 0 )
    grid_brew.addWidget( @trub_loss_box, 4, 1, 1, 3 )
    grid_brew.addWidget( dead_loss_label, 5, 0 )
    grid_brew.addWidget( @dead_loss_box, 5, 1, 1, 3 )
    grid_brew.addWidget( rate_boil_off_label, 6, 0 )
    grid_brew.addWidget( @rate_boil_off_box, 6, 1, 1, 3 )
    grid_brew.addWidget( shrinkage_label, 7, 0 )
    grid_brew.addWidget( @shrinkage_box, 7, 1, 1, 3 )    
    grid_brew.setRowStretch( 8, 1 )
    grid_brew.setColumnStretch( 4, 1 )

    return grid_brew
  end

  def create_brew_recipe_grid
    @mash_volume = 0
    @sparge_volume = 0
    @preboil_volume = 0
    @orig_gravity = 0
    @final_gravity = 0
    @abv = 0

    grid_recipe = Qt::GridLayout.new

    grid_recipe.setColumnStretch( 0, 1 )

    @mash_volume_label = Qt::Label.new( "Mash volume: #{@mash_volume} gal", self )
    grid_recipe.addWidget( @mash_volume_label, 0, 1 )

    @sparge_volume_label = Qt::Label.new( "Sparge volume: #{@sparge_volume} gal", self )
    grid_recipe.addWidget( @sparge_volume_label, 1, 1 )

    @preboil_volume_label = Qt::Label.new( "Preboil volume: #{@preboil_volume} gal", self )
    grid_recipe.addWidget( @preboil_volume_label, 2, 1 )

    @og_label = Qt::Label.new( "Original gravity: #{@orig_gravity}", self )
    grid_recipe.addWidget( @og_label, 3, 1 )

    @fg_label = Qt::Label.new( "Final gravity: #{@final_gravity}", self )
    grid_recipe.addWidget( @fg_label, 4, 1 )

    @abv_label = Qt::Label.new( "ABV: #{@abv}", self )
    grid_recipe.addWidget( @abv_label, 5, 1 )

    grid_recipe.setRowStretch( 6, 1 )
    grid_recipe.setColumnStretch( 3, 1 )

    return grid_recipe
  end

  def create_brew_button_vbox
    # Create buttons and assign signals
    @brew_button_save = Qt::PushButton.new( "Save", self )
    connect( @brew_button_save, SIGNAL( "clicked()" ), SLOT( "brew_save_clicked()" ) )
    @brew_button_save.setEnabled( false )

    @brew_button_cancel = Qt::PushButton.new( "Cancel", self )
    connect( @brew_button_cancel, SIGNAL( "clicked()" ), SLOT( "brew_cancel_clicked()" ) )
    @brew_button_cancel.setEnabled( false )

    # Create vertical box for the buttons
    vbox = Qt::VBoxLayout.new
    		
    vbox.addStretch( 1 )
    vbox.addWidget( @brew_button_save )
    vbox.addWidget( @brew_button_cancel )

    return vbox
  end

  # Controls the hidding and showing of boxes based on the combo
  def on_activated text
    @type = text.downcase
    if( text == "Grain" )
      self.set_boxes_grain
    end

    if( text == "Hops" )
      self.set_boxes_hops
    end

    if( text == "Yeast" )
      self.set_boxes_yeast
    end
  end

  def set_boxes_grain
    @alpha_box.hide
    @beta_box.hide
    @ppg_box.show
    @efficiency_box.show
    @attenuation_box.hide
    @mass_box.show
    @unit_box.show
    @unit_box.removeItem( 0 )
    @unit_box.removeItem( 0 )
    @unit_box.addItem( "lbs" )
    @unit_box.addItem( "Kg" )
    @unit = "lbs"
  end

  def set_boxes_hops
    @alpha_box.show
    @beta_box.show
    @ppg_box.hide
    @efficiency_box.hide
    @attenuation_box.hide
    @mass_box.show
    @unit_box.show
    @unit_box.removeItem( 0 )
    @unit_box.removeItem( 0 )
    @unit_box.addItem( "oz" )
    @unit_box.addItem( "g" )
    @unit = "oz"
  end

  def set_boxes_yeast
    @alpha_box.hide
    @beta_box.hide
    @ppg_box.hide
    @efficiency_box.hide
    @attenuation_box.show
    @mass_box.hide
    @unit_box.hide
  end

  # Functions that update data from the GUI
  def on_name_changed name
    @name = name
  end

  def on_mass_changed mass
    @mass = mass
  end

  def on_unit_activated unit
    @unit = unit.downcase
  end

  def on_ppg_changed ppg
    @ppg = ppg
  end

  def on_efficiency_changed eff
    @efficiency = eff
  end

  def on_alpha_changed alpha
    @alpha = alpha
  end

  def on_beta_changed beta
    @beta = beta
  end

  def on_attenuation_changed att
    @attenuation = att
  end

  def on_final_volume_changed vol
    @final_volume = vol
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_mash_ratio_changed ratio
    @mash_ratio = ratio
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_mash_ratio_loss_changed ratio
    @mash_ratio_loss = ratio
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_boil_time_changed time
    @boil_time = time
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_trub_loss_changed loss
    @trub_loss = loss
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_dead_loss_changed loss
    @dead_loss = loss
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_rate_boil_off_changed rate
    @rate_boil_off = rate
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  def on_shrinkage_changed shrink
    @shrinkage = shrink
    @brew_button_save.setEnabled( true )
    @brew_button_cancel.setEnabled( true )
  end

  # Set the curently highlighted item 
  def item_clicked item
    @current_item = item
  end
  
  # The add button is also used to save when in edit mode, call the correct function
  def add_clicked
    button = sender

    if( button.text == "Add" )
      self.add_item
    elsif( button.text == "Save" )
      self.save_item
    end
  end

  def add_item
    case @type
    # Send current info to controller
    when "grain"
      if( @name != nil )
        # TODO For all cases we need a check to see if this @name already exists and display a dialog
        @controller.add_grain( @name, @mass, @unit, @ppg, @efficiency )
      else
        # TODO For all cases add a dialog saying that it needs a name
        puts "Error: need a name!"
      end
    when "hops"
      if( @name != nil )
        @controller.add_hops( @name, @alpha, @beta, @mass, @unit )
      else
        puts "Error: need a name!"
      end
    when "yeast"
      if( @name != nil )
        @controller.add_yeast( @name, @attenuation )
      else
        puts "Error: need a name!"
      end
    end
    # Cleanup the buttons and text fields
    self.cancel_item
  end

  def save_item
    case @type
    when "grain"
      @controller.update_grain( @name, @mass, @unit, @ppg, @efficiency )
    when "hops"
      @controller.update_hops( @name, @mass, @unit, @alpha, @beta )
    when "yeast"
      @controller.update_yeast( @name, @attenuation )
    end
    # Clean up the buttons and text fields
    self.cancel_item
  end

  def edit_item
    # Dont edit on the header text, that is fixed
    if( @current_item != @grain_header && @current_item != @hops_header && @current_item != @yeast_header )
      # Update the buttons
      @button_add.text = "Save"
      @button_remove.text = "Cancel"
      @button_edit.setEnabled( false )
      @type_combo.setEnabled( false )
      # TODO possibly make it so you can change the name, thus removing the current
      # item and adding a different type but with the same values, for now disable it
      @name_box.setEnabled( false )
      # Is the current row a grain, hop, or yeast?
      # Load the data from the list item
      if( @item_list.currentRow <= @end_of_grains )
        @type_combo.setCurrentIndex( 0 )
        @type = "grain"
        self.set_boxes_grain
        @name_box.setText( (@current_item.data Qt::UserRole).toString )
        @mass_box.setText( (@current_item.data Qt::UserRole+1).toString )
        index = @unit_box.findText( (@current_item.data Qt::UserRole+2).toString, Qt::MatchFixedString )
        @unit_box.setCurrentIndex( index )
        @ppg_box.setText( (@current_item.data Qt::UserRole+3).toString )
        @efficiency_box.setText( (@current_item.data Qt::UserRole+4).toString )
      elsif( @item_list.currentRow <= @end_of_hops )
        @type_combo.setCurrentIndex( 1 )
        @type = "hops"
        self.set_boxes_hops
        @name_box.setText( (@current_item.data Qt::UserRole).toString )
        @mass_box.setText( (@current_item.data Qt::UserRole+1).toString )
        index = @unit_box.findText( (@current_item.data Qt::UserRole+2).toString, Qt::MatchFixedString )
        @unit_box.setCurrentIndex( index )
        @alpha_box.setText( (@current_item.data Qt::UserRole+3).toString )
        @beta_box.setText( (@current_item.data Qt::UserRole+4).toString )
      else
        # Allowing name change for yeast since its so simple
        @name_box.setEnabled( true )
        @type_combo.setCurrentIndex( 2 )
        @type = "yeast"
        self.set_boxes_yeast
        @name_box.setText( (@current_item.data Qt::UserRole).toString )
        @attenuation_box.setText( (@current_item.data Qt::UserRole+1).toString )  
      end
    end
  end

  def remove_clicked
    button = sender

    if( button.text == "Remove" )
      self.remove_item
    elsif( button.text == "Cancel" )
      self.cancel_item
    end
  end

  def remove_item
    # Dont delete the header text, that is fixed
    if( @current_item != @grain_header && @current_item != @hops_header && @current_item != @yeast_header )
      # Is this a grain hops or yeast?
      if( @item_list.currentRow <= @end_of_grains )
        # Get the grain type from the data
        @controller.remove_grain( @item_list.currentItem().data( Qt::UserRole ).toString() )
      elsif( @item_list.currentRow <= @end_of_hops )
        @controller.remove_hops( @item_list.currentItem().data( Qt::UserRole ).toString() )
      else
        @controller.remove_yeast()
      end
    end
  end

  def cancel_item
    @button_add.text = "Add"
    @button_remove.text = "Remove"
    @button_edit.setEnabled( true )
    
    # Re-enable the combo box and name box
    @type_combo.setEnabled( true )
    @name_box.setEnabled( true )

    # Clear the text fields when we cancel
    @name_box.setText ""
    @mass_box.setText ""
    @ppg_box.setText ""
    @efficiency_box.setText ""
    @alpha_box.setText ""
    @beta_box.setText ""
    @attenuation_box.setText ""
  end

  def brew_save_clicked
    @controller.update_values( @final_volume, @mash_ratio, @mash_ratio_loss, @boil_time,
                               @trub_loss, @dead_loss, @rate_boil_off, @shrinkage )
  end

  def brew_cancel_clicked
    @final_volume = @old_final_volume
    @final_volume_box.setText( @final_volume.to_s )

    @mash_ratio = @old_mash_ratio
    @mash_ratio_box.setText( @mash_ratio.to_s )

    @mash_ratio_loss = @old_mash_ratio_loss
    @mash_ratio_loss_box.setText( @mash_ratio_loss.to_s )

    @boil_time = @old_boil_time
    @boil_time_box.setText( @boil_time.to_s )

    @trub_loss = @old_trub_loss
    @trub_loss_box.setText( @trub_loss.to_s )

    @dead_loss = @old_dead_loss
    @dead_loss_box.setText( @dead_loss.to_s )

    @rate_boil_off = @old_rate_boil_off
    @rate_boil_off_box.setText( @rate_boil_off.to_s )

    @shrinkage = @old_shrinkage
    @shrinkage_box.setText( @shrinkage.to_s )

    @brew_button_save.setEnabled( false )
    @brew_button_cancel.setEnabled( false )
  end

  # Receive the updated brew data and update the GUI with it
  def brew_update b
    @display_brew = b

    # Update misc brew values
    @mash_volume = @display_brew.volume_mash.volume
    @sparge_volume = @display_brew.volume_sparge.volume
    @preboil_volume = @display_brew.volume_preboil.volume
    @orig_gravity = @display_brew.gravity_original
    @final_gravity = @display_brew.gravity_final
    @abv = @display_brew.percent_abv

    # Update brew recipe in the brews tab
    mash_str = "Mash volume: %.3f gal" % [@mash_volume]
    @mash_volume_label.setText( mash_str )
    sparge_str = "Sparge volume: %.3f gal" % [@sparge_volume]
    @sparge_volume_label.setText( sparge_str )
    preboil_str = "Preboil volume: %.3f gal" % [@preboil_volume]
    @preboil_volume_label.setText( preboil_str )
    og_str = "Original gravity: %.3f" % [@orig_gravity]
    @og_label.setText( og_str )
    fg_str = "Final gravity: %.3f" % [@final_gravity]
    @fg_label.setText( fg_str )
    abv_str = "ABV: %.2f" % [@abv]
    @abv_label.setText( abv_str )

    # Clear out the old grains
    while( @end_of_grains > 0 )
        @item_list.takeItem( 1 )
        @end_of_grains -= 1
        @end_of_hops -= 1
        @end_of_yeast -= 1
    end
    @grain_strings = Array.new

    # Recreate grains list
    @display_brew.grains.each_with_index do |grain, index|
      text = sprintf( "%-16s| %-8.2f| %-7s| %-4d| %-11.1f|", grain.type, grain.mass, grain.unit, grain.ppg_potential, grain.percent_efficiency )
      @grain_strings << text

      # Create ListWidgetItem and store data in it
      item = Qt::ListWidgetItem.new( @grain_strings[index] )
      item.setFont( @font )
      item.setData( Qt::UserRole, Qt::Variant.from_value( grain.type ) )
      item.setData( Qt::UserRole+1, Qt::Variant.from_value( grain.mass ) )
      item.setData( Qt::UserRole+2, Qt::Variant.from_value( grain.unit ) )
      item.setData( Qt::UserRole+3, Qt::Variant.from_value( grain.ppg_potential ) )
      item.setData( Qt::UserRole+4, Qt::Variant.from_value( grain.percent_efficiency ) )

      @item_list.insertItem( @end_of_grains+1, item )
      @end_of_grains += 1
      @end_of_hops += 1
      @end_of_yeast += 1
    end

    # Clear out the old hops
    while( @end_of_hops > @end_of_grains + 1)
        @item_list.takeItem( @end_of_grains + 2 )
        @end_of_hops -= 1
        @end_of_yeast -= 1
    end
    @hops_strings = Array.new

    @display_brew.hops.each_with_index do |hops, index|
      text = sprintf( "%-16s| %-8.2f| %-7s| %-8.1f| %-8.1f|", hops.type, hops.mass, hops.unit, hops.alpha, hops.beta )
      @hops_strings << text

      item = Qt::ListWidgetItem.new( @hops_strings[index] )
      item.setFont( @font )
      item.setData( Qt::UserRole, Qt::Variant.from_value( hops.type ) )
      item.setData( Qt::UserRole+1, Qt::Variant.from_value( hops.mass ) )
      item.setData( Qt::UserRole+2, Qt::Variant.from_value( hops.unit ) )
      item.setData( Qt::UserRole+3, Qt::Variant.from_value( hops.alpha ) )
      item.setData( Qt::UserRole+4, Qt::Variant.from_value( hops.beta ) )

      @item_list.insertItem( @end_of_hops+1, item )
      @end_of_hops += 1
      @end_of_yeast += 1
    end

    # clear out the old yeast
    if( @end_of_yeast > @end_of_hops+1 ) 
      @item_list.takeItem( @end_of_yeast )
      @end_of_yeast -= 1
    end

    if( @display_brew.yeast != nil )
      yeast = @display_brew.yeast
      text = sprintf( "%-16s| %-11.2f |", yeast.name , yeast.percent_attenuation )

      item = Qt::ListWidgetItem.new( text )
      item.setFont( @font )
      item.setData( Qt::UserRole, Qt::Variant.from_value( yeast.name ) )
      item.setData( Qt::UserRole+1, Qt::Variant.from_value( yeast.percent_attenuation ) )

      @item_list.insertItem( @end_of_yeast+1, item )
      @end_of_yeast += 1
    end

    # Update items in brews tabs
    @final_volume = @old_final_volume = @display_brew.volume_final.volume.to_f
    @final_volume_box.setText( @final_volume.to_s )

    @mash_ratio = @old_mash_ratio = @display_brew.ratio_mash
    @mash_ratio_box.setText( @mash_ratio.to_s )

    @mash_ratio_loss = @old_mash_ratio_loss = @display_brew.ratio_mash_loss
    @mash_ratio_loss_box.setText( @mash_ratio_loss.to_s )

    @boil_time = @old_boil_time = @display_brew.min_boil_time
    @boil_time_box.setText( @boil_time.to_s )

    @trub_loss = @old_trub_loss = @display_brew.volume_trub_loss.volume.to_f
    @trub_loss_box.setText( @trub_loss.to_s )

    @dead_loss = @old_dead_loss = @display_brew.volume_mash_dead_loss.volume.to_f
    @dead_loss_box.setText( @dead_loss.to_s )

    @rate_boil_off = @old_rate_boil_off = @display_brew.rate_boil_off
    @rate_boil_off_box.setText( @rate_boil_off.to_s )

    @shrinkage = @old_shrinkage = @display_brew.percent_shrinkage
    @shrinkage_box.setText( @shrinkage.to_s )

    # Make sure the buttons are disabled after updating
    @brew_button_save.setEnabled( false )
    @brew_button_cancel.setEnabled( false )
  end
  
end
