import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// One bar block for network throughput, RAM, CPU temperature and CPU load.
// Font and spacing come from Style, so it follows `[font] base-size` in
// shell.toml like the built-in widgets. scripts/sysmon.sh supplies raw
// counters; rates are computed here against this instance's last sample.
BarWidget {
  id: root

  readonly property int criticalTemp: Number(setting("criticalTemp", 85))
  readonly property color foreground: bar ? bar.barForeground : Color.foreground

  readonly property string iconWifi: String.fromCodePoint(0xF0928)
  readonly property string iconWired: String.fromCodePoint(0xF0002)
  readonly property string iconOffline: String.fromCodePoint(0xF05AA)
  readonly property string iconMemory: String.fromCodePoint(0xF061A)
  readonly property string iconTemp: String.fromCodePoint(0xF050F)
  readonly property string iconCpu: String.fromCodePoint(0xF035B)

  property var last: null
  property string netText: ""
  property string memText: ""
  property string tempText: ""
  property string cpuText: ""
  property bool tempHot: false
  property string tooltip: ""

  visible: !vertical
  implicitWidth: visible ? stats.implicitWidth + Style.spacing.controlPaddingX * 2 : 0
  implicitHeight: barSize

  function human(bytes) {
    if (bytes >= 1073741824) return (bytes / 1073741824).toFixed(2) + "GB"
    if (bytes >= 1048576) return (bytes / 1048576).toFixed(1) + "MB"
    return (bytes / 1024).toFixed(1) + "KB"
  }

  function update(raw) {
    var s
    try { s = JSON.parse(raw) } catch (e) { return }

    var now = Date.now()
    var prev = last
    var dt = prev ? Math.max(0.001, (now - prev.time) / 1000) : 0
    // Interface switches reset the byte counters; show zero instead of a bogus spike.
    var sameIface = prev && prev.iface === s.iface
    var down = sameIface ? Math.max(0, (s.rx - prev.rx) / dt) : 0
    var up = sameIface ? Math.max(0, (s.tx - prev.tx) / dt) : 0
    var cpuDelta = prev ? s.cpuTotal - prev.cpuTotal : 0
    var cpu = cpuDelta > 0 ? Math.round(100 * (cpuDelta - (s.cpuIdle - prev.cpuIdle)) / cpuDelta) : 0
    s.time = now
    last = s

    // Fixed-width numbers keep the block from jittering as values change.
    netText = s.iface
      ? (s.wireless ? iconWifi : iconWired) + " ↓" + human(down).padStart(7) + "/s ↑" + human(up).padStart(7) + "/s"
      : iconOffline

    var usedG = ((s.memTotal - s.memAvail) / 1048576).toFixed(1)
    var totalG = Math.round(s.memTotal / 1048576)
    var memPct = s.memTotal > 0 ? Math.round((s.memTotal - s.memAvail) / s.memTotal * 100) : 0
    memText = iconMemory + " " + usedG.padStart(4) + "G/" + totalG + "G (" + String(memPct).padStart(2) + "%)"

    tempText = iconTemp + " " + s.temp + "°C"
    tempHot = s.temp >= criticalTemp
    cpuText = iconCpu + " " + String(cpu).padStart(2) + "%"

    tooltip = "Interface: " + (s.iface || "disconnected")
      + "\nMemory: " + usedG + "G used of " + totalG + "G"
      + "\nCPU temperature: " + s.temp + "°C"
      + "\nCPU load: " + cpu + "%"
  }

  component Stat: Text {
    anchors.verticalCenter: parent.verticalCenter
    textFormat: Text.PlainText
    font.family: Style.font.family
    font.pixelSize: Style.font.body
  }

  Row {
    id: stats
    anchors.centerIn: parent
    spacing: Style.spacing.xxl

    Stat { text: root.netText; color: root.foreground }
    Stat { text: root.memText; color: root.foreground }
    Stat { text: root.tempText; color: root.tempHot && root.bar ? root.bar.urgent : root.foreground }
    Stat { text: root.cpuText; color: root.foreground }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: if (root.bar) root.bar.run(String(root.setting("onClick", "omarchy-launch-or-focus-tui btop")))
    onEntered: if (root.bar) root.bar.showTooltip(root, root.tooltip)
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }

  Process {
    id: sampler
    command: ["bash", "-c", "~/.config/omarchy/bar/scripts/sysmon.sh"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.update(text)
    }
  }

  Timer {
    interval: Math.max(1, Number(root.setting("interval", 2))) * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!sampler.running) sampler.running = true
  }
}
