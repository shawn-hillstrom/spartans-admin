# Spartan's Admin Version 2.0 [Beta]

## About

Spartan's Admin is an administrative system built for use in Roblox's game development environment. The system allows priviledged users to administrate their games using a variety of commands. These commands are detailed in **Spartans_Admin_[Beta].lua** under the **[Variables & other necessities]** section.

**NOTE:** This code is out of date with the newest version of Roblox's development environment and may not perform as intended.

## Versioning

**VERSION:** 2.0

**RELEASE:** Beta

**LAST UPDATED:** April 11th, 2013

## Resources

**Spartans_Admin_[Beta].lua:** Contains everything necessary to implement the main functionality of Spartan's Admin.

**Command_Code.lua:** Helper file which loads global code inputted into the command line.

**Local_Command_Code.lua:** Helper file which loads local code inputted into the command line.

## How To Use

**Spartans_Admin_[Beta].lua** must be inserted into the game's ServerScriptService with **Command_Code.lua** and **Local_Command_Code.lua** as child scripts. Each child script must also have a text element called **'*Code*'**. These text elements are not included here.

Additionally, Spartan's Admin requires several child GUI objects. These GUIs must have specific structures and names which are described in **Spartans_Admin_[Beta].lua**. None of these GUIs are included here.

## Future Development

Future development plans include adding more commands and updating the current system to conform with the newest features in Roblox's development environment.
