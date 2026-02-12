;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu system accounts)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
	     (rosenthal services networking))
(use-service-modules cups desktop networking ssh xorg containers)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "rd-srv")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "main")
                  (comment "Main")
                  (group "users")
                  (home-directory "/home/main")
                  (supplementary-groups '("cgroup" "wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
    (cons* (service elogind-service-type)
	   (service openssh-service-type)
	   (service network-manager-service-type)
	   (service wpa-supplicant-service-type)
	   (service ntp-service-type)
	   (service tailscale-service-type)

	   (service iptables-service-type)

	   (service rootless-podman-service-type
                   (rootless-podman-configuration
                     (subgids
                      (list (subid-range (name "main"))))
                     (subuids
                      (list (subid-range (name "main"))))))
           
	   (service oci-service-type
	     (oci-configuration
	       (runtime 'podman)))

	   (simple-service 'atlas-oci-service
			   oci-service-type
			   (oci-extension
			     (containers
			       (list
				 (oci-container-configuration
				   (image "nicolargo/glances:latest")
				   (ports '(("61208" . "61208")))
				   (auto-start? #t)
				   (respawn? #t)
				   (environment
				     (list '("GLANCES_OPT" . "-w"))))))))
	%base-services))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "709cc165-bf4a-4339-b45e-c6bad58cb4e5")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "7F7A-46AD"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "cd1db22b-0e5d-4091-a385-f1906e8b7d43"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
