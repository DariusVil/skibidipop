# Skibidipop

## _Diff stacking tool_

[![Skibidipop](https://github.com/DariusVil/skibidipop/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/DariusVil/skibidipop/actions/workflows/swift.yml)

Skibidipop is a diff stacking (branch chaining) tool for Git repositories.

## Installation

Skibidipop requires [Swift compiler](https://www.swift.org/download/) to be built. After you've cloned the repo run:

```sh
./install.sh
```

This script will build the binary and move it to `/usr/local/bin` if you give it permission to do that. Likely you already have it in your path and can execute `skibidipop`
```Swift
skibidipop <command> [<branch name>]
```

## Commands

| Command | Description |
| ------ | ------ |
| chain | creates a new branch, checkouts into it, adds and commits any changes. This command requires branch name. |
| list | lists active chain |
| rebase | rebases all branches in an active chain from it's oldest branch |
| sync | pushes all branches in active chain |
| nuke | cleans all metadata stored in ~/.skibidipop|
