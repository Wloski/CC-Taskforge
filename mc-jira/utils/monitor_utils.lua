local monitor = peripheral.find("monitor")
assert(monitor, "No monitor found!")
local monitorWidth, monitorHeight = monitor.getSize()

return {
    monitor = monitor,
    width = monitorWidth,
    height = monitorHeight
}