extends Node

func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	
	var token: String = "c2z28grC6DCkEGgx6tG8jnx9Cic1GzV6qrIamItO";
	$HTTPRequest.request("https://itch.io/api/1/" + token + "/me");
	print('request made');

func _on_request_completed(result, response_code, headers, body):
	print('request completed');
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	var id = json['user']['id'];
	print(id);
	
	var name = json['user']['username'];
	print(name);
	
	var avatar = json['user']['cover_url'];
	print(avatar);
