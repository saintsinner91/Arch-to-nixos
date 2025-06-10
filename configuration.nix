{ config, pkgs, ... }:

{
      # ... (your existing i3 configuration) ...

        environment.systemPackages = with pkgs; [
                # ... (other packages you've installed, e.g., dmenu, i3status) ...
                    gnome-disk-utility # Add GNOME Disk Utility here
                        # gptfdisk # Recommended if you plan to use it for advanced partitioning (includes sgdisk)
        ];

          # This is often needed for disk utilities to function correctly.
            # It ensures that D-Bus services for UDisks2 are properly set up.
              services.dbus.packages = [ pkgs.gnome-disk-utility ];

                # If you want to allow non-root users to manage disks without passwords,
                  # you might need to configure Polkit. However, this is more advanced and
                    # should be done carefully. By default, it will likely prompt for password.
                      # services.polkit.enable = true;
                        # security.sudo.extraConfig = ''
                          #   %your_user_group ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/gnome-disks
                            # '';
}

        ]
}