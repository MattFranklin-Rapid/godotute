# Godot Mobile Project
This project seeks to learn the minimum requirements to go from raw Godot Project to deployed mobile app

## Colliders

🟦 Blue -> Physics Collision
🟩 Green -> Behaviour Detectors
🟥 Red -> Hurtboxes
🟨 Yellow -> Attackboxes & Hitboxes

## Collision Layers

1) Enviroment - For colliding with the static brushes of the world
2) Player - For pushing the player around
3) Enemy - For pushing NPCs around
4) Danger - For envrionment to deal damage to entities
5) Player Hurt Box - For hurting the player
6) Enemy Hurt Box - For hurting NPCs

## Components
All components are self documented. Be aware of

- Actor
  - Player
  - Enemy
- AttackBoxComponent
- HitBoxComponent
- HurtBox
- Spike Base
