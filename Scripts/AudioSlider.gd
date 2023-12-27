extends HSlider

@export var bus_name: String;

var bus_index: int;

func _ready():
    bus_index = AudioServer.get_bus_index(bus_name)
    if bus_index == -1:
        print("Bus not found: " + bus_name)
        return

    value_changed.connect(_on_value_changed);

    # Set initial value.
    var initial = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
    set_value_no_signal(initial);

func _on_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
