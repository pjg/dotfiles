#!/usr/bin/env python

# Scrape colors from GTK and import them into Wine through the registry
# 
# endolith@gmail.com 2009-02-06
# 
# Based on script by KillerKiwi [Ubuntu Forums] October 29th, 2007
# http://ubuntuforums.org/showthread.php?t=55286&page=3#23
# 
# which is based on patch by Johannes Roith [Mono-winforms-list] Wed, 27 Aug 2003
# http://lists.ximian.com/pipermail/mono-winforms-list/2003-August/000469.html

# Taken from:
# https://gist.github.com/endolith/74192/


import pygtk
import gtk
import os
from tempfile import NamedTemporaryFile
from gconf import Client
import re


# TODO: command line switch
debug_mode = False

def format_color_string(Color):
    """ Convert 48-bit gdk.Color to 24-bit 'RRR GGG BBB' triple. """
    if type(Color) is gtk.gdk.Color:
        return '%s %s %s' % (Color.red/256, Color.green/256,  Color.blue/256)
    else:
        print('Not a GdkColor: ' + str(Color))
        return None

def format_hex_color(color):
    """ Convert from hex color string to decimal 'RRR GGG BBB' triple. """
    if re.match('^#[0-9a-fA-F]{12}$', color):
        r, g, b = color[1:3], color[5:7], color[9:11] #rrrrggggbbbb
    elif re.match('^#[0-9a-fA-F]{6}$', color):
        r, g, b = color[1:3], color[3:5], color[5:7]  #RRGGBB
    elif re.match('^#[0-9a-fA-F]{3}$', color):    
        r, g, b = color[1]*2, color[2]*2, color[3]*2  #09C becomes 0099CC.
    else:
        print('Cannot understand color string format: ' + str(color))
        return None
    return '%s %s %s' % (int(r,16), int(g,16), int(b,16))

# TODO: fonts

# Get some colors from GTK
# gtk.Style object:
# http://www.moeraki.com/pygtkreference/pygtk2reference/class-gtkstyle.html

# Create a window to scrape colors from
window = gtk.Window()

button = gtk.Button()
vbox = gtk.VBox()
vbox.add(button)

scrollbar =  gtk.VScrollbar()
vbox.add(scrollbar)

menubar = gtk.MenuBar()
menuitem = gtk.MenuItem()
menubar.add(menuitem)
vbox.add(menubar)

window.add(vbox)

# On show_all(), these are all converted from gtk.Style objects with wrong
# colors into __main__.EngineStyle objects with correct colors.
window.show_all()

# Tooltips
# http://www.daa.com.au/pipermail/pygtk/2005-November/011353.html
tooltip = gtk.Window()
tooltip.set_name('gtk-tooltips')
tooltip.show_all()

# Mappings for all the color values (described in readme.txt)
# TODO: Need to mark which colors do not work with which themes and double-check EVERYTHING
# * = Confirmed to work exactly for all themes (except Darklooks)
# + = Not perfect, but close?
# ? = Nothing to scrape? - Chose something similar

gtk_colors = {

# Title bars can't be accessed from PyGTK(?) so I just guessed to 
# make it work reasonably well with themes like Human.
# Default Windows theme: Darker on left, light on right
'TitleText':             window.style.white                    , #? White since we're guessing on dark selection color for titlebar
'InactiveTitleText':     window.style.white                    , #? White since we're guessing on dark selection color for titlebar
'ActiveTitle':           window.style.dark[gtk.STATE_SELECTED] , #? Guess on selection color like Clearlooks
'InactiveTitle':         window.style.dark[gtk.STATE_NORMAL]   , #? Darker color for gradient
'GradientActiveTitle':   window.style.light[gtk.STATE_SELECTED], #? Lighter version for gradient
'GradientInactiveTitle': window.style.base[gtk.STATE_NORMAL]   , #? Guess on base color   
'ActiveBorder':          button.style.bg[gtk.STATE_INSENSITIVE], #? Same as ButtonFace like Clearlooks
'InactiveBorder':        button.style.bg[gtk.STATE_INSENSITIVE], #? Same as ButtonFace

'AppWorkSpace': window.style.base[gtk.STATE_NORMAL], #? MDI not used in GTK; use same color as Window, like Glade
'Background':   None                               , #* Scraped from gconf below

'ButtonText':          button.style.fg[gtk.STATE_NORMAL]        , #* 
'ButtonHilight':       button.style.light[gtk.STATE_INSENSITIVE], #* 
'ButtonLight':         button.style.bg[gtk.STATE_INSENSITIVE]   , #* Usually same as ButtonFace?
'ButtonFace':          button.style.bg[gtk.STATE_INSENSITIVE]   , #* 
'ButtonAlternateFace': button.style.bg[gtk.STATE_INSENSITIVE]   , #* Set to same as ButtonFace for now
'ButtonShadow':        button.style.dark[gtk.STATE_INSENSITIVE] , #* 
'ButtonDkShadow':      button.style.black                       , #* 

'GrayText':         window.style.fg[gtk.STATE_INSENSITIVE], #*
'Hilight':          window.style.base[gtk.STATE_SELECTED] , #*
'HilightText':      window.style.fg[gtk.STATE_SELECTED]   , #*
'HotTrackingColor': window.style.light[gtk.STATE_NORMAL]  , #? Doesn't seem to exist in GTK; use lighter ButtonFace color, like CompizConfig Settings Manager

'InfoText':    tooltip.style.fg[gtk.STATE_NORMAL],
'InfoWindow':  tooltip.style.bg[gtk.STATE_NORMAL],

'Menu':        menuitem.style.light[gtk.STATE_ACTIVE],
'MenuBar':     menubar.style.bg[gtk.STATE_NORMAL]    ,
'MenuHilight': menuitem.style.bg[gtk.STATE_SELECTED] ,
'MenuText':    menuitem.style.fg[gtk.STATE_NORMAL]   ,

'Scrollbar':   scrollbar.style.bg[gtk.STATE_ACTIVE], #+ Not right, even though gtk.RcStyle documentation says it is
'Window':      window.style.base[gtk.STATE_NORMAL] , #* base or bg?
'WindowFrame': button.style.mid[gtk.STATE_SELECTED], #+ bg selected or light selected?
'WindowText':  window.style.text[gtk.STATE_NORMAL] , #* 
}

# As far as I know, there is no way to programmatically extract colors from GTK for the same elements in any engine, so we'll have to add engine-specific scrapers.
# "Engines can and do whatever they want with the colors from the rc file ... A theme includes both the colors, and the code that paints using colors. So the code can use any of the colors it wants."
# TODO: something like this:

print "GTK engine:",

if 'ClearlooksStyle' in repr(window.style):  # kludgy, but works
    print "Clearlooks"
    # assign different colors to some elements
elif  'MurrineStyle' in repr(window.style):
    print "Murrine"
    gtk_colors.update({'Window': window.style.base[gtk.STATE_NORMAL]})
elif 'CruxStyle' in repr(window.style):
    print "Crux"
else:
    print "unknown"
     
# QtPixbufStyle GlideStyle PixbufStyle HcStyle IndustrialStyle MistStyle ThiniceStyle darklooks = gtk.Style



# Create list of formatted color value pair strings
# Windows registry values are in the form "name"="data" with no spaces
color_pairs = []
for name, data in gtk_colors.iteritems():
    if data:
        color_pairs.append('"%s"="%s"' % (name, format_color_string(data)))


# Get Desktop background color from Gnome's GConf, append to color pair list
c = Client()
desktop_color = format_hex_color(c.get_value('/desktop/gnome/background/primary_color'))
if desktop_color:
    color_pairs.append('"Background"="%s"' % desktop_color)

# TODO: Get Desktop background color from Xfce
# import xfce4?
# "i see, yes xfce does have something like that. you find it in /home/$USER/.config/xfce4/mcs_settings/desktop.xml"


# Create a temporary Windows .reg registry file with the new values
# I'm not sure of the meaning of S-1-5-4.  This may not work on all systems? 
# I do know it is the same number under multiple accounts.
try:
    wineprefix = os.environ['WINEPREFIX']
except KeyError:
    wineprefix = os.path.join(os.environ['HOME'],'.wine')
winetemp = os.path.join(wineprefix, 'drive_c','windows','temp')
f = NamedTemporaryFile(prefix = 'winecolors', suffix = '.reg', dir = winetemp, mode = 'w+')
f.write("""REGEDIT4

[HKEY_USERS\S-1-5-4\Control Panel]

[HKEY_USERS\S-1-5-4\Control Panel\Colors]
""")

# Alphabetize list (purely so that user.reg is easy to read; Wine doesn't care)
color_pairs = sorted(color_pairs)

# Append list to file, with newlines
f.writelines(line + '\n' for line in color_pairs)
f.flush()

# Debugging
if debug_mode:
    print '---- [' + f.name + '] ----'
    f.seek(0)
    for line in f:
        print line,
    print '--------\n'

# Import values into Wine registry using regedit command
print('Using regedit to import colors into registry...\n')
os.system('regedit ' + f.name)
# TODO: Check if this worked correctly.  

# Delete temporary file
f.close()

print('Done importing colors')

# TODO: catch errors from regedit not working?
