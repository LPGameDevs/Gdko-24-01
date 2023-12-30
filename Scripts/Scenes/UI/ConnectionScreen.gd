extends "res://Scripts/Extensions/Screen.gd"

@onready var tab_container := $TabContainer
@onready var login_email_field := $TabContainer/Login/GridContainer/Email
@onready var login_password_field := $TabContainer/Login/GridContainer/Password
@onready var login_save_checkbox := $TabContainer/Login/GridContainer/SaveCheckBox
@onready var create_account_tab := $"TabContainer/Create Account"
@onready var create_account_username_field = $"TabContainer/Create Account/GridContainer/Username"
@onready var create_account_save_checkbox := $"TabContainer/Create Account/GridContainer/SaveCheckBox"
@onready var forgot_password_tab = $"TabContainer/Forgot password?"

const CREDENTIALS_FILENAME = 'user://credentials.json.enc'
const CREDENTIALS_FILENAME_OLD = 'user://credentials.json'

const FORGOT_PASSWORD_URL = 'https://www.snopekgames.com/player/forgot-password'

var email: String = ''
var password: String = ''

var _reconnect: bool = false
var _next_screen

enum LoginType {
	EMAIL,
}
var _login_type = LoginType.EMAIL

func _ready() -> void:
	tab_container.set_tab_title(0, "SESSION_SETUP_TAB_LOGIN")
	tab_container.set_tab_title(1, "SESSION_SETUP_TAB_CREATE_ACCOUNT")
	tab_container.set_tab_title(2, "SESSION_SETUP_TAB_FORGOT_PASSWORD")

	tab_container.current_tab = 0


	if FileAccess.file_exists(CREDENTIALS_FILENAME):
		var file = FileAccess.open_encrypted_with_pass(CREDENTIALS_FILENAME, FileAccess.READ, "Build.encryption_password"); 
		if file != null:
			_load_credentials(file)

func _set_credentials(_email: String, _password: String) -> void:
	email = _email
	password = _password

	login_email_field.text = email
	login_password_field.text = password

func _load_credentials(file: FileAccess) -> void:
	var result = JSON.parse_string(file.get_as_text())
	if result.result is Dictionary:
		_set_credentials(result.result['email'], result.result['password'])
	file.close()

func _save_credentials() -> void:
	var file = FileAccess.open_encrypted_with_pass(CREDENTIALS_FILENAME, FileAccess.WRITE, "Build.encryption_password")
	var credentials = {
		email = email,
		password = password,
	}
	file.store_line(JSON.stringify(credentials))
	file.close()

func _show_screen(info: Dictionary = {}) -> void:
	_reconnect = info.get('reconnect', false)
	_next_screen = info.get('next_screen', 'MatchScreen')

	tab_container.current_tab = 0

	# If we have a stored email and password, attempt to login straight away.
	if email != '' and password != '':
		do_login()
		return

func do_login(save_credentials: bool = false) -> void:
	_login_type = LoginType.EMAIL
	visible = false

	if _reconnect:
		ui_layer.show_message("MESSAGE_SESSION_EXPIRED")
		_reconnect = false
	else:
		ui_layer.show_message("MESSAGE_SESSION_LOGGING_IN")

	var nakama_session = await Online.nakama_client.authenticate_email_async(email, password, null, false)

	if nakama_session.is_exception():
		visible = true
		login_email_field.grab_focus()
		ui_layer.show_message("MESSAGE_LOGIN_FAILED")

		# Clear stored email and password, but leave the fields alone so the
		# user can attempt to correct them.
		email = ''
		password = ''

		# We always set Online.nakama_session in case something is yielding
		# on the "session_changed" signal.
		Online.nakama_session = null
	else:
		if save_credentials:
			_save_credentials()

		Online.nakama_session = nakama_session

		ui_layer.hide_message()

		if _next_screen:
			ui_layer.show_screen(_next_screen)
	visible = false

func _on_LoginButton_pressed() -> void:
	email = login_email_field.text.strip_edges()
	password = login_password_field.text.strip_edges()
	do_login(login_save_checkbox.pressed)

func _on_CreateAccountButton_pressed() -> void:
	email = $"TabContainer/Create Account/GridContainer/Email".text.strip_edges()
	password = $"TabContainer/Create Account/GridContainer/Password".text.strip_edges()

	var username = $"TabContainer/Create Account/GridContainer/Username".text.strip_edges()
	var save_credentials = create_account_save_checkbox.pressed

	if email == '':
		ui_layer.show_message("MESSAGE_EMAIL_REQUIRED")
		return
	if password == '':
		ui_layer.show_message("MESSAGE_PASSWORD_REQUIRED")
		return
	if username == '':
		ui_layer.show_message("MESSAGE_USERNAME_REQUIRED")
		return

	visible = false
	ui_layer.show_message("MESSAGE_CREATING_ACCOUNT")

	var nakama_session = await Online.nakama_client.authenticate_email_async(email, password, username, true)

	if nakama_session.is_exception():
		visible = true
		create_account_username_field.grab_focus()

		var msg = nakama_session.get_exception().message
		# Nakama treats registration as logging in, so this is what we get if the
		# the email is already is use but the password is wrong.
		if msg == 'Invalid credentials.':
			msg = 'MESSAGE_EMAIL_TAKEN'
		elif msg == '':
			msg = 'MESSAGE_CREATE_ACCOUNT_FAILED'
		ui_layer.show_message(msg)

		# We always set Online.nakama_session in case something is yielding
		# on the "session_changed" signal.
		Online.nakama_session = null
	else:
		if save_credentials:
			_save_credentials()
		#Online.nakama_session = nakama_session
		ui_layer.hide_message()
		ui_layer.show_screen("MatchScreen")

func _on_ResetPasswordButton_pressed() -> void:
	var email = $"TabContainer/Forgot password?/GridContainer/Email".text.strip_edges()

	if email == '':
		ui_layer.show_message("MESSAGE_EMAIL_REQUIRED")
		return

	var http_request := HTTPRequest.new()
	add_child(http_request)

	ui_layer.show_message("MESSAGE_PASSWORD_RESET_SENDING")

	var data :=  {
		form_id = "custom_forgot_password_form",
		email = email,
		op = "submit",
	}

	var http_client := HTTPClient.new()
	var query_string: String = http_client.query_string_from_dict(data)

	var headers := ["Content-Type: application/x-www-form-urlencoded"]
	if http_request.request(FORGOT_PASSWORD_URL, headers, HTTPClient.METHOD_POST, query_string) != OK:
		http_request.queue_free()
		ui_layer.show_message("MESSAGE_PASSWORD_RESET_FAILED")
		return

	http_request.request_completed.connect(self._on_ResetPasswordButton_request_completed)


func _on_ResetPasswordButton_request_completed(result, response_code, headers, body) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code >= 400:
		#http_request.queue_free()
		ui_layer.show_message("MESSAGE_PASSWORD_RESET_FAILED")
		return

	ui_layer.show_message("MESSAGE_PASSWORD_RESET_SENT")
