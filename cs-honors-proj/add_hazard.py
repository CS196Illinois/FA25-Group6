with open('Scenes/quad.tscn', 'r') as f:
    content = f.read()

# Find the position to insert
search_str = '[node name="MovingHazard3" parent="Hazards" instance=ExtResource("5_hazard")]\nposition = Vector2(-50, -100)\n'
replacement = search_str + '\n[node name="GroundHazard" parent="Hazards" instance=ExtResource("5_hazard")]\nposition = Vector2(-100, -16)\nmove_speed = 70.0\nmove_distance = 200.0\n'

content = content.replace(search_str, replacement)

with open('Scenes/quad.tscn', 'w') as f:
    f.write(content)

print("Ground hazard added successfully!")
