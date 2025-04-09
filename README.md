<h1>
  Harrek's Healer Ramp Helper
</h1>

> The Healer Ramp Helper is a tool designed to help healers manage their cooldowns in order to properly execute ramps. It works similarly to assigning every part of a ramp's instructions as warnings or reminders but facilitates this process by automatically creating reminders for all the steps based on the best recommended practices for the spec.

[CurseForge AddOn Page](https://www.curseforge.com/wow/addons/harreks-healer-ramp-helper)

<h2>
  How does it work
</h2>

[The main file](HarreksHealerRampHelper.lua) contains the functions that make the addon work, the frames that handle all the events and their associated calls are here. [The Options file](Options.lua) has the code for the in-game options window, and manages all the settings and savedVariables for the addon. The options window uses AceGUI and AceConfig,
[The Data file](Data.lua) containes predefined data about the specs the addon supports, the boss fights of the current tier and the difficuly IDs. And the spec files in [the ClassData folder](ClassData/) have all the information to make a specific spec and their ramps work with the rest of the addon

<h2>
  Contribuing
</h2>

The main way to contribue is to edit the apropiate spec file for the specialization you want to change to make their ramps better reflect reality. The rest of the addon automatically pulls the information from the RampTypes function in each class' spec file, so changing the information there would change how the addon plays for that spec

<h2>
  Contact
</h2>

If you have any problem with the addon feel free to open an issue, or you can contact me directly in the [Spiritbloom.Pro discord](https://discord.gg/MMjNrUTxQe)
