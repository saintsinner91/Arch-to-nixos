{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
              ./hardware-configuration.nix
                  ];

                    # Bootloader.
                      boot.loader.systemd-boot.enable = true;
                        boot.loader.efi.canTouchEfiVariables = true;

                          # Networking
                            networking.hostName = "nixos-vincenzo"; # Define your hostname
                              networking.networkmanager.enable = true; # Enable NetworkManager for easy network configuration

                                # Time and locale settings
                                  time.timeZone = "America/Toronto"; # Adjust to your timezone
                                    i18n.defaultLocale = "en_US.UTF-8";

                                      # Enable the X server (graphical environment)
                                        services.xserver.enable = true;

                                          # Enable i3 as the window manager
                                            services.xserver.windowManager.i3.enable = true;

                                              # Set i3 as the default display manager session.
                                                # This assumes you are using a display manager (like LightDM or SDDM).
                                                  # If you prefer to start i3 manually from a TTY, you can comment this out.
                                                    services.displayManager.defaultSession = "none+i3";

                                                      # Enable a display manager (choose one, or comment out if you prefer CLI login)
                                                        # For LightDM (common and lightweight):
                                                          services.displayManager.lightdm.enable = true;
                                                            # For SDDM (Qt-based, common with KDE Plasma, but works fine with i3):
                                                              # services.displayManager.sddm.enable = true;

                                                                # Configure your user account
                                                                  users.users.vincenzo = {
                                                                        isNormalUser = true;
                                                                            extraGroups = [ "wheel" "networkmanager" ]; # "wheel" grants sudo access, "networkmanager" allows network control
                                                                                initialPassword = "your-secure-password"; # <--- CHANGE THIS TO A STRONG PASSWORD
                                                                                    shell = pkgs.zsh; # Example: Use zsh as the default shell
                                                                                        # Add other groups if needed, e.g., "lp" for printing, "audio" for sound
                                                                  };

                                                                    # Add packages to the system environment. These will be available to all users.
                                                                      environment.systemPackages = with pkgs; [
                                                                            # Basic utilities
                                                                                git # Version control
                                                                                    vim # Text editor
                                                                                        wget # File downloader
                                                                                            curl # Another file downloader
                                                                                                htop # Process viewer
                                                                                                    neofetch # System info
                                                                                                        unzip # Archive utility

                                                                                                            # i3-specific tools (highly recommended)
                                                                                                                dmenu # Application launcher
                                                                                                                    i3status # Basic status bar (consider i3status-rust or polybar for more features)
                                                                                                                        i3lock # Screen locker
                                                                                                                            i3blocks # Modular status bar for i3status
                                                                                                                                rofi # More advanced application launcher/switcher

                                                                                                                                    # Terminal emulator
                                                                                                                                        alacritty # Fast, GPU-accelerated terminal (or choose kitty, foot, etc.)

                                                                                                                                            # File manager
                                                                                                                                                pcmanfm # Lightweight file manager (or nautilus, thunar, etc.)

                                                                                                                                                    # Image viewer/wallpaper setter
                                                                                                                                                        feh # Great for setting wallpapers

                                                                                                                                                            # GNOME Disk Utility
                                                                                                                                                                gnome-disk-utility # Graphical disk and partition manager
                                                                                                                                                                    gptfdisk # Provides sgdisk, which gnome-disk-utility sometimes relies on

                                                                                                                                                                        # GTK Theme Configuration (for consistent looks with GTK apps in i3)
                                                                                                                                                                            lxappearance # Configure GTK themes, icons, fonts

                                                                                                                                                                                # Web browser
                                                                                                                                                                                    firefox # Or chromium, brave, etc.
                                                                      ];

                                                                        # Services needed for gnome-disk-utility and other graphical applications
                                                                          services.dbus.packages = [ pkgs.gnome-disk-utility ];

                                                                            # Some global settings (optional, but good to know)
                                                                              nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enable new Nix features

                                                                                # Enable sound with PipeWire.
                                                                                  sound.enable = true;
                                                                                    hardware.pulseaudio.enable = false; # Disable PulseAudio if PipeWire is used
                                                                                      security.rtkit.enable = true;
                                                                                        services.pipewire = {
                                                                                              enable = true;
                                                                                                  alsa.enable = true;
                                                                                                      alsa.support32Bit = true;
                                                                                                          pulse.enable = true;
                                                                                                              # If you want to use WirePlumber (recommended for PipeWire)
                                                                                                                  # media-session.enable = false;
                                                                                                                      # wireplumber.enable = true;
                                                                                        };

                                                                                          # Enable touchpad support (synaptics driver)
                                                                                            services.xserver.libinput.enable = true; # Modern input driver

                                                                                              # OpenSSH server for remote access
                                                                                                services.openssh.enable = true;

                                                                                                  # Enable the firewall
                                                                                                    networking.firewall.enable = true;
                                                                                                      # networking.firewall.allowedTCPPorts = [ 22 ]; # Example: Allow SSH

                                                                                                        # This value determines the NixOS release from which the default
                                                                                                          # settings for stateful data, like file locations and database versions
                                                                                                            # on your system were placed. It's currently the same as the release version of
                                                                                                              # the channel you are currently running.
                                                                                                                system.stateVersion = "23.11"; # Don't change this until you know what you're doing
}

                                                                                        }
                                                                      ]
                                                                  }
}