KEY_COMBINATION="<Control><Alt>w"
INSTALL_DIR=/usr/share/textual-switcher
LOCKFILE_PATH=${XDG_RUNTIME_DIR}/textual-switcher.pid
KEY_BINDING="${INSTALL_DIR}/launch"
CHROME_EXTENSION_ID=ebgonmbbfgmoiklncphoekdfkfeaenee

.PHONY: install
install:
	@echo 'Installing... (see log in "installation.log")'.
	@$(MAKE) requirements >> installation.log 2>&1
	@$(MAKE) launch >> installation.log 2>&1
	@echo Installing switcher scripts... >> installation.log 2>&1
	@sudo mkdir -p ${INSTALL_DIR}
	@sudo cp switcher.py windowcontrol.py listfilter.py tabcontrol.py pidfile.py glib_wrappers.py launch browser-agent/api_proxy_native_app.py ${INSTALL_DIR}
	@echo Creating PID file... >> installation.log 2>&1
	@touch ${LOCKFILE_PATH}
	@echo Setting the keyboard shortcut... >> installation.log 2>&1
	@$(MAKE) install_firefox_extension >> installation.log 2>&1
	@$(MAKE) install_chrome_extension >> installation.log 2>&1
	@python apply-binding.py ${KEY_BINDING} ${KEY_COMBINATION}
	@echo Installation complete.
	@echo
	@echo Note:
	@echo "* Activate: "${KEY_COMBINATION}"  (a reboot might be needed)."
	@echo "* You might need to approve the Firefox extension (in Firefox) for support of listing Firefox tabs."

launch: launch.c
	@gcc -Wall -Werror -pedantic -std=c99 launch.c -o launch

.PHONY: requirements
requirements:
	@./install-prerequisites.sh

.PHONY: install_firefox_extension
install_firefox_extension:
	@echo Installing the Firefox extension... >> installation.log 2>&1
	@mkdir -p ~/.mozilla/extensions/{\ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/
	@cp browser-agent/firefox-tablister-extension/textual_switcher_agent-1.0-an+fx.xpi ~/.mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/{c60f517c-ccd3-4ec2-a289-0d9fe8e3cdf5}.xpi
	@echo Installing the API proxy manifest for the Firefox extension... >> installation.log 2>&1
	@mkdir -p ~/.mozilla/native-messaging-hosts/
	@cp browser-agent/firefox-tablister-extension/api_proxy_native_app.json ~/.mozilla/native-messaging-hosts/

.PHONY: install_chrome_extension
install_chrome_extension:
	@echo Installing the Chrome extension... >> installation.log 2>&1
	@sudo mkdir -p /usr/share/google-chrome/extensions/
	@sudo chown $$USER:$$USER /usr/share/google-chrome/extensions/
	@sudo cp browser-agent/chrome-tablister-extension/preferences-file.json /usr/share/google-chrome/extensions/${CHROME_EXTENSION_ID}.json
	@sudo chmod +r /usr/share/google-chrome/extensions/${CHROME_EXTENSION_ID}.json
	@echo Installing the API proxy manifest for the Chrome extension... >> installation.log 2>&1
	@mkdir -p ~/.config/google-chrome/NativeMessagingHosts/
	@cp browser-agent/chrome-tablister-extension/api_proxy_native_app.json ~/.config/google-chrome/NativeMessagingHosts/
