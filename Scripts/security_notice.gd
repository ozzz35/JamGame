class_name SecurityNotice extends ColorRect

@onready var day_number_label: Label = $VBoxContainer/Day/DayNumber

@onready var employee_number_label: Label = $VBoxContainer/Subject/EmployeeNumber
@onready var password_label: Label = $VBoxContainer/Password
@onready var shadow: TextureRect = $shadow


func setup(employee_number: int, day_number: int, password: String):
	day_number_label.text = "0" + str(day_number)
	employee_number_label.text = str(employee_number)
	
	var spaced_code := ""
	for c in password:
		spaced_code += c + " "
	password_label.text += "ACCESS CODE:  %s\n\n" % spaced_code.strip_edges()
