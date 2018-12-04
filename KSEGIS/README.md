<h2 aligh="center">KSEGIS [se:gis] - Krey's Super Emergefull Gentoo Installation Script</h2>

This is a krey's fork of <a href="https://github.com/bogdanseczkowski/OPTINUX">bogdanseczkowski/OPTINUX</a>.

**THIS SCRIPT SHOULD NEVER BE USED! IT IS IN WORK IN PROGRESS!!**<br />
**THIS SCRIPT SHOULD NEVER BE USED! IT IS IN WORK IN PROGRESS!!**<br />
**THIS SCRIPT SHOULD NEVER BE USED! IT IS IN WORK IN PROGRESS!!**<br />
**THIS SCRIPT SHOULD NEVER BE USED! IT IS IN WORK IN PROGRESS!!**<br />
**THIS SCRIPT SHOULD NEVER BE USED! IT IS IN WORK IN PROGRESS!!**<br />

# Ethical codex
  1. Never sacrifice optimization over automatization
  2. If you make optimization that is not ideall for the end-user system like using mtune=native inform him/her about making manual optimization later and mark it with #TODO.
  3. Always add logs so that end-user can review the changes.
  4. Never remove any data without the user-input and asking the user twice for confirmation.

# Features/Planned Features
  - [ ] **Forking stage3 from gentoo to be used with KSEGIS.**
    - [ ] Gentoo
      - [ ] amd64/i363
    - [ ] Argent
    - [ ] Calculate Linux
    - [ ] CloverOS

  - [ ] **TUI logo introduction upon invoke**
    - [X] To increase the cool factor
    - [ ] Animate it and pin to terminal's top using tmux(?)
      - [ ] Make it optional

  - [X] **Idiot Check** (Temporary untill finished)
    - To warn the user that the script is not finished
    
  - [X] **Aquiring root access while script is invoked**
    - [X] using `sudo` without the need to reinvoke the script
    - [X] using `su` without the need to reinvoke the script
    - [X] proceed if user is already root
  
  - [X] **Dependancy check**
    - Working, but not super-emergefull.

  - [ ] **Partitioning**
    - [ ] Terminal User Interface
      - [X] using cfdisk
        - [ ] partitions defined by user (manual)
        - [ ] partitions defined by script (automatically)
      - [X] using fdisk
        - [ ] partitions defined by user (manual)
        - [ ] partitions defined by script (automatically)
      - [X] using parted
        - [ ] partitions defined by user (manual)
        - [ ] partitions defined by script (automatically)
    - [ ] Graphical User Interface
      - [ ] using gparted
        - [ ] partitions defined by user (manual)
        - [ ] partitions defined by script (automatically)
    - [ ] User-input
      - [ ] TODO
    
  - [ ] **Other TODO**
    - [ ] Automatic MAKE OPTS
    - [ ] automatic cflags generation (instead of -mtune=native)
    - [ ] Add loging to a custom location or default. 
    - [ ] Install GPU drivers based on end-user hardware.
    - [ ] Make KSEGIS callable via terminal with defined commands for each step so that it could be used to make.conf for example.
