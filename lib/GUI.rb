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
         'on_attenuation_changed(QString)' )

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

    settings_tab = Qt::Widget.new self
    tab_manager.addTab( settings_tab, "Brew Settings" )

		setWindowTitle "Brew App"
	
    # unispaced font so the stext can form nice columns
	  @font = Qt::Font.new()
    @font.setFamily("Courier New")
	  
    # Create the ingredients layout
		ingredients_tab.layout = self.create_ingredients
		
    # Create the settings layout
    settings_tab.layout = self.create_settings

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

  def create_settings
    grid_settings = Qt::GridLayout.new

    final_volume_label = Qt::Label.new( "Final Volume", self )
    final_volume = Qt::LineEdit.new self
    mash_ratio_label = Qt::Label.new( "Mash Ratio", self )
    mash_ratio = Qt::LineEdit.new self
    mash_ratio_loss_label = Qt::Label.new( "Mash Loss Ratio", self )
    mash_ratio_loss = Qt::LineEdit.new self
    boil_time_label = Qt::Label.new( "Boil Time", self )
    boil_time = Qt::LineEdit.new self
    trub_loss_label = Qt::Label.new( "Trub Loss", self )
    trub_loss = Qt::LineEdit.new self
    dead_loss_label = Qt::Label.new( "Dead Loss", self )
    dead_loss = Qt::LineEdit.new self
    rate_boil_off_label = Qt::Label.new( "Rate Boil Off", self )
    rate_boil_off = Qt::LineEdit.new self
    shrinkage_label = Qt::Label.new( "Shrinkage", self )
    shrinkage = Qt::LineEdit.new self


    grid_settings.addWidget( final_volume_label, 0, 0 )
    grid_settings.addWidget( final_volume, 0, 1, 1, 3 )
    grid_settings.addWidget( mash_ratio_label, 1, 0 )
    grid_settings.addWidget( mash_ratio, 1, 1, 1, 3 )
    grid_settings.addWidget( mash_ratio_loss_label, 2, 0 )
    grid_settings.addWidget( mash_ratio_loss, 2, 1, 1, 3 )
    grid_settings.addWidget( boil_time_label, 3, 0 )
    grid_settings.addWidget( boil_time, 3, 1, 1, 3 )
    grid_settings.addWidget( trub_loss_label, 4, 0 )
    grid_settings.addWidget( trub_loss, 4, 1, 1, 3 )
    grid_settings.addWidget( dead_loss_label, 5, 0 )
    grid_settings.addWidget( dead_loss, 5, 1, 1, 3 )
    grid_settings.addWidget( rate_boil_off_label, 6, 0 )
    grid_settings.addWidget( rate_boil_off, 6, 1, 1, 3 )
    grid_settings.addWidget( shrinkage_label, 7, 0 )
    grid_settings.addWidget( shrinkage, 7, 1, 1, 3 )    
    grid_settings.setRowStretch( 8, 1 )
    grid_settings.setColumnStretch( 4, 1 )

    return grid_settings
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

  # TODO When the add button is clicked and boxes are not filled out an error occurs.
  # We need to display a dialog if required info is missing and be ok with non required
  # data being empty
  # TODO We should probably only allow adding one of a certain type of grain. Whats the
  # point of having 2 "Wheats", the ammounts could just be added to the existing one
  def add_item
    case @type
    # Send current info to controller
    when "grain"
      if( @name != nil )
        @controller.add_grain( @name, @mass, @unit, @ppg, @efficiency )
      else
        puts "Error: need a name!"
      end
    when "hops"
      @controller.add_hops( @name, @alpha, @beta, @mass, @unit )
    when "yeast"
      @controller.add_yeast( @name, @attenuation )
    end
  end

  def save_item
    case @type
    when "grain"
      # TODO call edit grain 
    when "hops"
    when "yeast"
    end
    self.cancle_item
  end

  def edit_item
    if( @current_item != @grain_header && @current_item != @hops_header && @current_item != @yeast_header )
      @button_add.text = "Save"
      @button_remove.text = "Cancel"
      @button_edit.setEnabled( false )
      # TODO Disable the type combo box so the user does not do confusing things while edditng
      if( @item_list.currentRow <= @end_of_grains )
        @type_combo.setCurrentIndex( 0 )
        self.set_boxes_grain
        @name_box.setText( (@current_item.data Qt::UserRole).toString )
        @mass_box.setText( (@current_item.data Qt::UserRole+1).toString )
        index = @unit_box.findText( (@current_item.data Qt::UserRole+2).toString, Qt::MatchFixedString )
        @unit_box.setCurrentIndex( index )
        @ppg_box.setText( (@current_item.data Qt::UserRole+3).toString )
        @efficiency_box.setText( (@current_item.data Qt::UserRole+4).toString )
      elsif( @item_list.currentRow <= @end_of_hops )
        @type_combo.setCurrentIndex( 1 )
        self.set_boxes_hops 
      else
        @type_combo.setCurrentIndex( 2 )
        self.set_boxes_yeast
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
    puts "remove_item()"
  end

  def cancel_item
    @button_add.text = "Add"
    @button_remove.text = "Cancel"
    @button_edit.setEnabled( true )
    # TODO Possibly clear the fields when we cancel
  end


  # Receive the updated brew data and update the GUI with it
  def brew_update b
    @display_brew = b

    @display_brew.grains.each_with_index do |grain, index|
      if( index+1 > @grain_strings.count )
        text = sprintf( "%-16s| %-8.2f| %-7s| %-4d| %-11.1f|", grain.type, grain.mass, grain.unit, grain.ppg_potential, grain.percent_efficiency )
        @grain_strings << text

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
    end

    @display_brew.hops.each_with_index do |hops, index|
      if( index+1 > @hops_strings.count )
        text = sprintf( "%-16s| %-8.2f| %-7s| %-8.1f| %-8.1f|", hops.type, hops.mass, hops.unit, hops.alpha, hops.beta )
        @hops_strings << text

        item = Qt::ListWidgetItem.new( @hops_strings[index] )
        item.setFont( @font )
        @item_list.insertItem( @end_of_hops+1, item )
        @end_of_hops += 1
        @end_of_yeast += 1
      end
    end

    if( @yeast_added == false )
      @yeast_added = true
      yeast = @display_brew.yeast
      text = sprintf( "%-16s| %-11.2f |", yeast.name , yeast.percent_attenuation )

      item = Qt::ListWidgetItem.new( text )
      item.setFont( @font )
      @item_list.insertItem( @end_of_yeast+1, item )
      @end_of_yeast += 1
    end

  end
  
end

