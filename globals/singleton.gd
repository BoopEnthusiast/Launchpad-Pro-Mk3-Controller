extends Node


var lp_pipe: Dictionary


func _enter_tree() -> void:
	lp_pipe = OS.execute_with_pipe("python.exe", ["launchpad.pyw"])
	OS.get_executable_path()
	print(lp_pipe)
	print(lp_pipe["stderr"].get_as_text())
	print(lp_pipe["stdio"].get_as_text())
	var io: FileAccess = lp_pipe["stdio"]
	lp_pipe["stdio"].store_line("quit")
	print(lp_pipe["stdio"])
	print(io.is_open())
	OS.kill(lp_pipe["pid"])
