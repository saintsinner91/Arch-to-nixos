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
                                    time.timeZone = "America/Toronto"; # Adjust to your timezone (e.g., "America/New_York", "Europe/London")
                                      i18n.defaultLocale = "en_US.UTF-8";

                                        # Enable the X server (graphical environment)
                                          services.xserver.enable = true;

                                            # Enable i3 as the window manager
                                              services.xserver.windowManager.i3.enable = true;

                                                # Set i3 as the default display manager session.
                                                  # This ensures you'll be dropped directly into i3 after login.
                                                    services.displayManager.defaultSession = "none+i3";

                                                      # Enable LightDM as the display manager for a graphical login screen.
                                                        services.displayManager.lightdm.enable = true;
                                                          # If you prefer SDDM (often used with KDE Plasma, but works fine with i3):
                                                            # services.displayManager.sddm.enable = true;

                                                              # Configure your user account
                                                                users.users.vincenzo = {
                                                                        isNormalUser = true;
                                                                            extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ]; # "wheel" for sudo, "networkmanager" for networking, "audio"/"video"/"input" for hardware access
                                                                                initialPassword = "your-secure-password"; # <--- CRITICAL: CHANGE THIS TO A STRONG PASSWORD
                                                                                    shell = pkgs.zsh; # Set zsh as the default shell for vincenzo
                                                                };

                                                                  # Configure Zsh program-wide features
                                                                    programs.zsh = {
                                                                            enable = true;
                                                                                enableCompletion = true; # Enable Zsh's powerful completion
                                                                                    autosuggestions.enable = true; # Enable command autosuggestions
                                                                                        syntaxHighlighting.enable = true; # Enable syntax highlighting in the shell

                                                                                            # Optional: Configure oh-my-zsh (uncomment and customize if desired)
                                                                                                # ohMyZsh = {
                                                                                                        #   enable = true;
                                                                                                            #   plugins = [ "git" "z" "fzf" "command-not-found" ]; # Add desired oh-my-zsh plugins
                                                                                                                #   theme = "robbyrussell"; # Or your preferred theme (e.g., "agnoster", "powerlevel10k")
                                                                                                                    # };

                                                                                                                        # Optional: Define system-wide Zsh aliases
                                                                                                                            # shellAliases = {
                                                                                                                                    #   ll = "ls -l";
                                                                                                                                        #   edit = "sudo -e";
                                                                                                                                            #   update = "sudo nixos-rebuild switch";
                                                                                                                                                #   docs = "nixos-help";
                                                                                                                                                    #   rb = "sudo nixos-rebuild switch"; # Shorthand for rebuild
                                                                                                                                                        # };

                                                                                                                                                            # Optional: Any extra commands to run when the shell starts for all zsh users
                                                                                                                                                                # initExtra = ''
                                                                                                                                                                    #   # Example: Set a custom prompt or environment variable
                                                                                                                                                                        #   export EDITOR="vim"
                                                                                                                                                                            # '';
                                                                    };


                                                                      # Add packages to the system environment. These will be available to all users.
                                                                        environment.systemPackages = with pkgs; [
                                                                                # Basic utilities
                                                                                    git # Version control
                                                                                        vim # Text editor
                                                                                            wget # File downloader
                                                                                                curl # Another file downloader
                                                                                                    htop # Process viewer
                                                                                                        neofetch # System information display
                                                                                                            unzip # Archive utility
                                                                                                                zip # Archive utility
                                                                                                                    p7zip # 7-Zip archive utility

                                                                                                                        # i3-specific tools (highly recommended for a functional i3 desktop)
                                                                                                                            dmenu # Simple application launcher
                                                                                                                                i3status # Basic status bar (you might consider i3status-rust or polybar for more features)
                                                                                                                                    i3lock # Screen locker
                                                                                                                                        i3blocks # Modular status bar for i3status, allows custom scripts
                                                                                                                                            rofi # More advanced and customizable application launcher/switcher and window switcher

                                                                                                                                                # Terminal emulator
                                                                                                                                                    alacritty # Fast, GPU-accelerated terminal emulator (or kitty, foot, gnome-terminal, etc.)

                                                                                                                                                        # File manager
                                                                                                                                                            pcmanfm # Lightweight and fast file manager (or nautilus, thunar, dolphin, etc.)

                                                                                                                                                                # Image viewer/wallpaper setter
                                                                                                                                                                    feh # Excellent for setting wallpapers in i3 and viewing images

                                                                                                                                                                        # GNOME Disk Utility (Disks application)
                                                                                                                                                                            gnome-disk-utility # Graphical tool for managing disks and partitions
                                                                                                                                                                                gptfdisk # Provides sgdisk, which is often a dependency for disk operations

                                                                                                                                                                                    # GTK Theme Configuration (for consistent looks with GTK applications in i3)
                                                                                                                                                                                        lxappearance # Tool to configure GTK themes, icons, fonts for GTK applications

                                                                                                                                                                                            # Web browser
                                                                                                                                                                                                firefox # Popular web browser (or chromium, brave, etc.)

                                                                                                                                                                                                    # Font packages (important for rendering text correctly, especially for status bars)
                                                                                                                                                                                                        font-awesome # Icons for status bars and other applications
                                                                                                                                                                                                            material-design-icons # Another set of popular icons
                                                                                                                                                                                                                dejavu_fonts # Common set of free fonts
                                                                        ];

                                                                          # Services needed for gnome-disk-utility and other graphical applications to communicate
                                                                            services.dbus.packages = [ pkgs.gnome-disk-utility ];

                                                                              # Sound configuration with PipeWire (recommended modern audio server)
                                                                                sound.enable = true;
                                                                                  hardware.pulseaudio.enable = false; # Disable PulseAudio if PipeWire is used
                                                                                    security.rtkit.enable = true;
                                                                                      services.pipewire = {
                                                                                            enable = true;
                                                                                                alsa.enable = true;
                                                                                                    alsa.support32Bit = true; # Needed for some 32-bit applications that use ALSA
                                                                                                        pulse.enable = true; # Provide PulseAudio compatibility layer
                                                                                                            # If you want to use WirePlumber (recommended session manager for PipeWire)
                                                                                                                media-session.enable = false; # Disable default media session
                                                                                                                    wireplumber.enable = true;
                                                                                      };

                                                                                        # Enable touchpad support using the modern libinput driver
                                                                                          services.xserver.libinput.enable = true;

                                                                                            # OpenSSH server for secure remote access (optional)
                                                                                              services.openssh.enable = true;

                                                                                                # Enable the firewall for basic security
                                                                                                  networking.firewall.enable = true;
                                                                                                    # Example: If you need to allow SSH connections from other machines:
                                                                                                      # networking.firewall.allowedTCPPorts = [ 22 ];

                                                                                                        # Configure file systems (mount points for additional drives)
                                                                                                          # Uncomment and modify these examples to mount your specific drives
                                                                                                            # fileSystems."/mnt/data" = {
                                                                                                                  #   device = "/dev/disk/by-uuid/YOUR_DATA_DRIVE_UUID"; # Use the UUID from `sudo blkid`
                                                                                                                    #   fsType = "ext4"; # e.g., "ext4", "ntfs", "vfat", "btrfs"
                                                                                                                      #   options = [ "defaults" "nofail" "noatime" ]; # "nofail" prevents boot issues if drive is missing
                                                                                                                        # };

                                                                                                                          # Example for an NTFS drive (e.g., a Windows partition or shared data drive)
                                                                                                                            # fileSystems."/mnt/windows_drive" = {
                                                                                                                                  #   device = "/dev/disk/by-uuid/YOUR_NTFS_DRIVE_UUID";
                                                                                                                                    #   fsType = "ntfs";
                                                                                                                                      #   # These options are crucial for user access to NTFS drives
                                                                                                                                        #   options = [ "defaults" "nofail" "uid=1000" "gid=100" "umask=022" ]; # Adjust uid/gid if 'vincenzo' isn't 1000/100
                                                                                                                                          # };

                                                                                                                                            # Enable new Nix features (nix-command and flakes) - useful for modern Nix workflows
                                                                                                                                              nix.settings.experimental-features = [ "nix-command" "flakes" ];

                                                                                                                                                # This value determines the NixOS release from which the default
                                                                                                                                                  # settings for stateful data, like file locations and database versions
                                                                                                                                                    # on your system were placed. It's currently the same as the release version of
                                                                                                                                                      # the channel you are currently running.
                                                                                                                                                        system.stateVersion = "23.11"; # Do not change this unless you are upgrading your NixOS channel and know the implications.
}

                                                                                                                            }
                                                                                                            }
                                                                                      }
                                                                        ]
                                                                                                                            }
                                                                                                }
                                                                    }
                                                                }
}