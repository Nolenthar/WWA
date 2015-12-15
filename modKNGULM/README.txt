modKNGULM v1.15
Modified by cvax. Original by KNGR.

---Changelog---
    --v1.15--
Bug fix:	When disabling ULM, it should not first do a ULM reload
Added:		Preset lightings for starters
Added:		New hot keys to increase/decrease envBlend and envPriority on-the-fly

	--v1.14--
Bug fix:	Previous environment hot key skipped the last environment when cycling backwards from CSLM
Bug fix:	Turbo Mode was still active even when "Enable Custom Lighting" was set to false
Improved:	In-game notifications of ULM actions
Improved:	Rebuilt menu system to better reflect ULM option relationships
Added:		New hot key to enable/disable ULM on-the-fly
Added:		New "favorites" that can be defined in the menus and hot keys to switch to them while in-game on-the-fly
Added:		New hot keys to save "favorites" while in-game


---Instructions---
Make sure to fully uninstall the old modKNGULM beforehand.
 - Remove all old KNGULM entries in <Witcher3>\bin\config\r4game\user_config_matrix\pc\input.xml
 - Delete kngmenu.xml from <Witcher3>\bin\config\r4game\user_config_matrix\pc\
 - Remove all KNGULM entries from input_qwerty.ini, input_azerty.ini, and input_qwertz.ini.
	These files are located in <Witcher3>\bin\config\r4game\legacy\base
	
Then follow all the steps in all the instruction files.


---Usage---
By default the hot keys are as follows:
	Enable/Disable ULM							- Hold NumPad8
	Reload ULM									- Press NumPad8
	Load Previous Environment Definition		- Press NumPad7
	Load Next Environment Definition			- Press NumPad9
	Load Favorite 1								- Press NumPad4
	Load Favorite 2								- Press NumPad5
	Load Favorite 3								- Press NumPad6
	Save Favorites Modifier						- Hold LShift + favorites hot key 1-3. (e.g. LShift+NumPad4 for saving favorite #1)
	envBlend Increase							- Press NumPad Plus
	envBlend Decrease							- Press NumPad Minus
	envPriority Increase						- Hold "Save Favorites Modifier" + NumPad Plus
	envPriority Decrease						- Hold "Save Favorites Modifier" + NumPad Minus