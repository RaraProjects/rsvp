_Note: Some features such as audible notifications when the timer reaches zero or chat reporting do not meet the HorizonXI addon standards and cannot be implemented with this addon._

This is an approved Horizon addon (06/26/24 addonreq-0604).

## How to Install
1. On the right side of the Github page (to the right of all the files) there is a section called "Releases".
2. Click the release that is marked as "Latest".
3. Inside the release there is a file called rsvp.zip. Download that. You don't need the "Source code" files.
5. Go to your download location and extract rsvp.zip. You should end up with a folder called "rsvp".
6. Put that "rsvp" folder in your addon folder. For Horizon it's probably something like ~/HorizonXI/Game/addons.

## Features
1. Local clock
2. Set a timer for {X} minutes in to the future. Quick buttons are available for common times.
3. Set a timer for a future real world time.
4. Create timer sets for HNMs. Set the first window and all subsequent windows will have timers automatically created.
5. HNM--or grouped--timers can be expanded to show the individual windows.
7. Timers are saved to a file so they will still be there if you log out or shut down.
8. Timers persist until you cancel them so you can see how overdue you are.

## Basic Timers
The main portion of the addon is the timer list and timer creation screen.<br><br>
![image](https://github.com/user-attachments/assets/54821bdb-44ae-4d4c-abae-0bf4191c0555)<br>
_Left: Timer List in Basic Mode showing some example timers. Right: RSVP Creation window showing the Relative timer options._

### Timer List
The timer list is designed to be visible most of the time.

#### Buttons at the Top
1. "+" : Opens and closes the RSVP Creation window.
2. Group: By default, grouped timers are collapsed and you can only see the nearest timer. Enabling Group Mode allows you to expand grouped timers and delete individual windows or the entire group.
3. Stamp: Toggles from countdown mode to timestamp mode. Timestamp mode lets you see the time you are counting down to. It's useful if you ever doubt that you typed the time in wrong.
4. Filt: You can configure a time filter in RSVP Settings that allows you to hide timers that are more than {X} amount of hours in the future. If you want to temporarily peak at those timers you can turn the filter off with this button to see them. The number in parenthesis shows how many timers are currently being filtered.

#### Grouping
Grouped timers are collapsed by default to save space. You can expand them to delete subsequent timers individually. You can also delete the whole group easily.

![image](https://github.com/user-attachments/assets/72d7576b-4536-4552-97c9-e12d46fe8243)<br>
_Example of an HNM timer that has the subsequent timers expanded._

### RSVP Creation
The RSVP Creation window is where you will create the timers. It has two sections based on what type of timer you are trying to create.<br><br>
![image](https://github.com/user-attachments/assets/fd9c00e0-c1a3-451e-b287-44ef4fe51f6e)<br>
_Left: Timer List in Group Mode. Right: RSVP Creation Window showing Specific timer options._

#### Relative 
Relative timers are created {X} amount of minutes into the future from the current time. If a mob dies now and it respawns in 5 minutes then you would create a Relative timer for 5 minutes to track its next spawn time. There are quick buttons available for some common times otherwise you can enter a custom amount of minutes. Relative timers do NOT require a name. If you want to quickly make a timer without thinking about a name just press the quick button or Create button and the timer will be created. Its name will be the timestamp that you are counting down to.
#### Specific
Specific timers are created by entering a specific date and time to count down to. There can be useful for HNMs or other events. Names are required for these and the time and dates need to be in the formats HH:MM:SS (AM/PM) and MM/DD/YY , respectively. The AM/PM is optional if you want to use 24-hour time. A timer preview is provided so that you can see what the addon thinks you're entering. The Sim: row is a simulation of what the timer will look like once created. Some quick buttons are available for creating timer groups for HNMs. The "10M7" buttons is for your 1-hour 10-minute windows like Fafnir (7 total windows). The "1H25" is for your 24-hour 1-hour windows like Tiamat (25 total windows). If you need to make a grouped timer with custom windows you can do that as well by expanding the "Custom Windows" drop down.

