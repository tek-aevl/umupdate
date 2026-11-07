# umupdate

**umupdate** is a modular Bash maintenance framework built to automate system updates, package cleanups, and fleet management across single hosts and multi-node homelab clusters. 

Whether running locally on Arch Linux workstation nodes or orchestrating updates across Debian, Ubuntu, Fedora, and FreeBSD virtual machines via SSH, `umupdate` turns routine server maintenance into a predictable, single-command workflow.

---

## Supported Package Managers & Environments

`umupdate` automatically detects and manages native package repositories as well as containerized desktop/application runtimes:

### Native System Package Managers
- **Arch Linux** (`pacman` / AUR helpers)
- **Debian / Ubuntu** (`apt` / `apt-get`)
- **Fedora** (`dnf`)
- **FreeBSD** (`pkg`)

### Application & Runtime Layer
- **Flatpak** (`flatpak update`)
- **Snapd** (`snap refresh`)

---

## Core Features & Workflow

- **Multi-Manager Updates**  
  Applies system distribution upgrades along with universal package layers (Flatpak, Snap) in a single unified execution pass.

- **Mass SSH Fleet Orchestration**  
  Execute parallel or sequential maintenance scripts across predefined host inventories without manual per-box intervention.

- **Kernel & Reboot Coordination**  
  Detects running vs. installed kernel versions (including custom kernel tracks such as `linux-zen`), flags required system reboots, and coordinates graceful node recycles.

- **Automated Pruning & Maintenance**  
  Cleans package caches, removes unneeded orphan dependencies, and safely trims log files to preserve disk space across virtualized storage backends.

- **Health Checks & Monitoring**  
  Performs pre-flight diagnostic checks (uptime, storage availability, active service states) before launching updates to prevent breaking live services.

- **Modular & Scriptable Design**  
  Completely transparent Bash scripts designed to be chained together, invoked manually via drop-down terminals, or scheduled through standard systemd timers and cron jobs.

---

## Design Philosophy

- **Simple, Auditable Shell Code:** Built entirely in plain Bash—no heavy, opaque frameworks or proprietary agents required.
- **Heterogeneous Fleet Management:** Designed to handle mixed environments featuring bare-metal hosts, Proxmox hypervisors, standard Linux/FreeBSD VMs, and LXC container hosts.
- **Boring Operations:** Makes "update everything everywhere" a reliable, low-risk habit.

---

## Intended Use Case

`umupdate` is designed for system administrators, homelab engineers, and multi-node operators managing diverse Linux/BSD infrastructure who want to eliminate tedious manual updating while keeping complete control over their shell environment.

---

*This is an evolving toolkit crafted from real-world admin workflows and continuously tuned for homelab reliability.*
