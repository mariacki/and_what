class_name StateMachine

var current: State

var _states: Dictionary[Script, State] = {}

func register_state(script: Script, state: State) -> void:
	assert(script not in _states, "State %s alread registered" % script)

	_states[script] = state


func switch_state(new_state_id: Script, context: Object) -> void:
	assert(new_state_id in _states, "Uregeistered state %s" % new_state_id)

	if current:
		current.exit(context)

	current = _states[new_state_id]
	current.enter(context)
