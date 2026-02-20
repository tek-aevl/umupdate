# umupdate

**umupdate** is a collection of Bash scripts for automating maintenance and update workflows across many machines. It’s built for mixed environments and is actively used in multi-host homelab and server fleets.

Supported platforms include:
- Arch Linux
- Debian / Ubuntu
- Fedora
- FreeBSD

## What it does

The scripts in this repo focus on **repeatable, low-friction system maintenance**, including:

- **Mass updates over SSH**  
  Run updates across a list of hosts from a single command, instead of babysitting each box.

- **Distro-aware update logic**  
  Uses the native tools for each platform (pacman, apt, dnf, pkg, etc.) and handles the differences for you.

- **Reboot coordination**  
  Separate steps for updating vs rebooting, with optional confirmation before you drop a whole fleet at once.

- **System state checks**  
  Scripts to inspect:
  - Running vs installed kernel versions
  - Uptime / reboot-needed state
  - Basic health and status info before or after updates

- **Cleanup and maintenance helpers**  
  Optional routines for:
  - Package cleanup / pruning
  - Cache cleanup
  - Log resets or trimming (where appropriate)

- **Composable, scriptable workflow**  
  The scripts are meant to be:
  - Chained together
  - Run manually or via cron/systemd timers
  - Customized per environment (IP lists, host groups, roles, etc.)

## Design goals

- Keep everything **simple, auditable, and shell-based**
- Prefer **explicit scripts over opaque automation frameworks**
- Work well in **heterogeneous fleets** (VMs, bare metal, SBCs, servers)
- Make “update all my stuff” a **boring, one-command operation**

## Who this is for

If you run:
- A homelab
- A small server fleet
- Mixed Linux/FreeBSD machines
- Or just too many boxes to update by hand

…this repo is meant to remove the busywork and make maintenance predictable.

---

This is an evolving toolkit, not a polished product. The scripts reflect real-world admin workflows and get adjusted as the fleet changes.