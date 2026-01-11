#!/usr/bin/env bash

cd ~/side-projects/prompts/codex/
cp -r ~/.codex/skills .
cp -r ~/.codex/prompts .
cp -r ~/.codex/scripts .
cp -r ~/.codex/tasks .
cp -r ~/.codex/AGENTS.md AGENTS.md 
cp -r ~/.codex/rules .
rm -rf skills/.system/
