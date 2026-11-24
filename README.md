# This is my Ultimate Anet AM8 Build

This printer has evolved over 10+ years of use to this.  
The original ABS parts started to crack so its time to reprint them and build my Ultimate AM8 to start producing Voron 2.4 parts.  
There are a few other mods possible on this printer but I think they are too much money for little return. The BLVMGN mod for the y axis and the Core XZ mod.  
The mods I am using have done me very well and I get very good quality prints.  
This machine uses no endstops uses the TMC2209 sensorless homing.  

Printer is running Klipper Firmware - Here is my configuration  
<https://github.com/ih8lag/am8_klipper>  

I use Orca Slicer as my slicer and here is my Orca config  
<https://github.com/ih8lag/orca_profiles>  

## Upgrades from stock

There is not much stock parts left on this machine.

- Helix Z screw couplers
- 24V Power supply and fans
- 24V Heated bed
- BTT SKR 2 board with TMC2209 steppers
- BTT EBB 42 in CAN mode
- Raspberry Pi 3
- Upgraded X Ends to Bear Extruder compatible
- Bear Direct Drive Extruder
- Aluminum Y Carriage
- Textured PEI Spring build plate
- Cork sheet under heatbed
- POM Z nuts
- Enclosure is a SKY Brand tent off amazon. Nothing fantastic but keeps the heat in when printing ABS parts
- Revo 6 Clone 40W hotend
- BTT U2C
- Clone 5 position wagos WAGO

The STLS are in the stls folder and the number in front is the number of parts to print  
Claude was used to remix and or create a few custom parts  
If an stl starts with TEST it was used to test fittment of the custom or remixed part  
If stl starts with OPTIONAL you dont need it its up to you  

Filament Black Elegoo ABS with red kxcelled as an accent color here and there  
Some non mechanical parts are printed in a black pla like the power supply mount/cover electrionics enclosure  
Print setttings for the mechanical parts are the settings for Voron parts 4 walls 4 top and bottom layers 40% infill.  
The Bear parts follow bear reccomendations  

SCAD included for custom parts  

## Sources for 3D printed parts

| Part | Source |
| --- | --- |
| Bear Extruder | <https://www.thingiverse.com/thing:4362586> |
| X Ends | <https://www.thingiverse.com/thing:3813648> |
| AM8 | <https://www.thingiverse.com/thing:2263216> |
| Z Gantry Jig | <https://www.thingiverse.com/thing:2325317> |
| Y Motor Mount | <https://www.thingiverse.com/thing:2403941/files> |
| TR8 Nut adapter | <https://www.thingiverse.com/thing:2695291/files> |
| PTFE Jig | <https://www.printables.com/model/178124-e3d-revo-6-six-ptfe-cutting-and-chamfer-tool-for-p> |
| Revo 6 Bear Cover | <https://www.printables.com/model/488513-bearexxa-v1-revo-cover-for-revo-6> |
| Y Belt Mount | <https://www.thingiverse.com/thing:4573353> |
| Electronics Case | <https://www.printables.com/model/173408-skr-14-turbo-hinged-electronics-case#preview.JCk4o> |
| Revo Sock | <https://www.printables.com/model/148160-e3d-revo-nozzle-full-silicone-sock-mould/files> |
| Build Plate Align | <https://www.thingiverse.com/thing:6617307> |
| Bolted tensioner | <https://www.thingiverse.com/thing:4612695> |
| Case Remixed From | <https://www.printables.com/model/173408-skr-14-turbo-hinged-electronics-case/files> |
| Fan Duct | <https://www.thingiverse.com/thing:3320490/files> |
| Wire Twister | <https://www.printables.com/model/499280-wire-twister/files> |
| Extrusion Clips | <https://www.thingiverse.com/thing:5204184/files> |

## What you need and where I got it?

- You will need all the parts from the AM8 build extrusions nuts screws etc... Mine was source from Misum years ago
- You can repurpose alot of your original Anet screws, nuts etc I chose to buy black socket/flat head hex screws for asthetic
- For the Bear extruder you will need the BMG gears and all the other pieces for that including pinda probe I sourced this from aliexpress and just bought a Prusa MK3 kit for the hardware
- They aluminum Y carriage was purchased off Aliexpress
- Im using a clone E3D Revo 6 nozzle with .4 mm nozzle with a 3d printed sock to help hold heat
- BTT SKR and power supply was purchased off amazon
- Helix Z couplers
- 24V bead was purchased from aliexpress
- Power supply was from Amazon
- Clone WAGOs from princess auto in Canada

## Build notes

- You should purchase a machinist square or other high prescision square like this <https://www.amazon.ca/gp/aw/d/B0CW2155F7?pd_rd_plhdr=t&hsa_cr_id=0&qid=1791057494&sr=1-1-5a5562f9-fdfd-4101-9f9d-d76aa9998432&i=aps> when assembling to keep your 90s as square as possible
- The Revo 6 Bear cover didnt fit properly. I had to cut out the table on the inside by the hotend
- The X idler expected a pin I reused the one i had which used a screw

## Assembly order

1. I reccomend on assembling the base frame loosely with the 4 corners and the 2020 90 degree brackets loosely on the top of the extrusion using your square on the outside of the bottom you can push the extrusions to touch the square and clamp
2. Then tighten down all the screws on that corner and repeat for the other 3 corners.
3. Move to the Z gantry you can do this how ever you prefer i would use a printable alignment jig for distance from back and use that on the outside to get the distance from the back and your precision squares to make sure its square
4. Do the same for the other side
5. Mount your Z motors using spacer jig
6. assemble all the Y pieces using supplied jigs
7. The Y tensioner needs post processing I have never gotten one of these to fit wthout some sanding or filing. File or sand the sliding piece until it slide freely with a little friction.

## Calibration

- <https://www.printables.com/model/70792-easy-3-axis-skew-calibration-tower-with-spreadshee/files> use this with the supplied instructions to calibrate skew i was out by less then .5mm after the rebuild
- Calibrate z offsets etc like normal
