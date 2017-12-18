# Interactive Timeline
Interactive timeline that allows to add tasks and manipulate them on the timeline.

Project under early development.
## Purpose
This project is intended to develop my iOS UI skills by creating timeline inspired by Hours app [https://www.hourstimetracking.com].
## Development plan
1. Define functionality of the timeline.
2. Breakdown functionality into tasks.
3. Write tasks along with unit tests (not necessary using TDD).
4. Look for further app purpose.

## Assumptions
- Written without external libraries
- Based on CGLayers - use as small UIViews as possible
- Do not use XIBs or Storyboards
- Design primarly on iPhone
- Supports iOS 11 and up
- Animated

## Functionality
- Updates with time. Timeline will slowly moves as times goes.
- Tap to add. Tapping on empty time slot will create task with it bounds. If no bound is defined then nearest rounded hour is taken.
- Tap to edit. If taken block is tapped, edit box is shown.
- Deletable. Task can be deleted.
- Task bounds can be edited. If bound reaches another task bound, then it is moved.
- Task cannot be smaller than 5 minutes.
- Scrollable. Timeline can be scrollable within last 24 hours (+1 one hour onward).
- Scaling. Time axis can be scalled by piching.
- Task must have name assigned.
- Duration shown. Task on timeline has its duration written.
- Timeline must have time axis described and current time should be marked.

## Tasks
1. Create project and upload it on GitHub
2. Remove Storyboards
3. Create simple ViewController view using code
4. Create static timeline axis
5. Make timeline scrollable
6. Make timeline show last 24h and 1h onward
7. Create nice time axis labels (every 5 min and every hour with label)
8. Make timeline dynamic (changes with time)
9. Add static blocks into timeline.
10. Improve static block view
11. Allow multiple static views on timeline.
12. Create started block (not finished) that enlarges during time
13. Create edit dialog after block is clicked
14. Add to dialog possibility of change title and time bounds.
15. Make dialog changes immediately change blocks
16. Animate dialog appearance
17. Scale timeline according to pinch gesture
18. Enable block bounds edit by long clicking bound and drag it.
19. Make neighbor bonds move along block's bounds

## Installation
Just open InteractiveTimeline.xcodeproj in Xcode and launch it.
## Usage
Play with timeline ;)
## Other
Any suggestions will be appreciated :)
