import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
	Variants {
		// Create the panel once on each monitor.
		model: Quickshell.screens

		PanelWindow {
			id: w

			property var modelData
			screen: modelData

			anchors {
				right: true
				bottom: true
			}

			margins {
				right: 50
				bottom: 50
			}

			implicitWidth: content.width
			implicitHeight: content.height

			color: "transparent"

			// Give the window an empty click mask so all clicks pass through it.
			mask: Region {}

			// Use the wlroots specific layer property to ensure it displays over
			// fullscreen windows.
			WlrLayershell.layer: WlrLayer.Overlay

			Image {
				id: content
				source: "https://raw.githubusercontent.com/SkettiSouls/nixos/refs/heads/master/etc/images/icons/mute.png"
			}
		}
	}
}
