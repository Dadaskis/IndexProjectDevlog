# IndexProject Devlog Framework

This repository contains a structured framework I built for creating developer logs (devlogs) using the Godot Engine. The project was designed to streamline the video editing process by leveraging Godot's node-based scene system as a non-linear editing environment.

## Overview

The framework provides a modular approach to devlog creation, allowing content to be assembled through Godot scenes rather than traditional video editing software. The structure separates content elements (scripts, visuals, audio) into reusable components that can be arranged and combined programmatically.

## Key Components

- **Scene-based editing**: Individual devlog segments are constructed as Godot scenes that can be nested, reused, and sequenced
- **Resource organization**: Dedicated directories for scripts, shaders, audio assets, and visual elements
- **Custom shader effects**: Pre-built visual filters including CRT emulation, loading screens, transitions, and video degradation effects
- **Audio management**: Timeline-aware audio controllers for music and sound effects

## Technical Structure

The framework organizes content into several key directories:
- `/scenes` - Core devlog segments and templates
- `/resources` - Reusable assets including scripts, shaders, fonts, and UI elements  
- `/plot` - Episode scripts and narrative outlines, those scripts are terrible lol
- `/.import` - Godot's automatically generated import assets

## Current Status

While this project was initially developed to support a series of development logs, I ultimately decided not to proceed with the devlog series. The repository remains available as a reference implementation for anyone interested in using Godot as a video editing environment or creating similar devlog tooling.

## Requirements

- Godot Engine 3.x
- Basic familiarity with Godot's scene system and GDScript
