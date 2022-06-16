# Minimal Fennel Love2D Setup

Derived from https://gitlab.com/alexjgriffith/min-love2d-fennel

Run the project with `love .`

You can enter `love .` in the main directory to run your game, or `make run`.

Replace all *TODO* entries in `Makefile` and `conf.lua`. Rename `src/todo-proj` and the corresponding imports in `src/game.fnl`

# Running in emacs

I use the following functions for running in emacs using `fennel-mode`.

```
(defun love-repl ()
  (interactive)
  (setq-local inferior-lisp-program (concat "love " (projectile-project-root) " --fennel --debug"))
  (run-lisp inferior-lisp-program))

(defun love-test ()
  (interactive)
  (setq-local inferior-lisp-program (concat "love " (projectile-project-root) " --fennel --test --repl --debug"))
  (run-lisp inferior-lisp-program))
```

# Release Process

Use `make linux`, `make windows`,  `make mac`, or `make web` to create targets for each platform, or `make release` to make all four. Check out the makefile for more commands, and remember to edit your game data in it!

### Targeting the development branch of love (12.0) - LINUX ONLY

You can target the development branch of love (version 12.0) by setting the `LOVE_VERSION` parameter in the makefile to 12.0. Note that because we are working from a github artifact, rather than a release, you will also have to pass in your github username and a github PAT.

### Getting a PAT

To download artifacts created by the Github actions CI you will need to get an access token from "settings -> developer settings -> personal access tokens". The token needs `workflow` and `actions:read` permissions.

#### Creating a credentials.private file

By default the makefile looks for `credentials.private` in the root directory of the project. `*.private` is part of `.gitignore` so personal information stored here will not be part of the git history or get pushed to a remote server.

The contents should look something like this:
```
GITHUB_USERNAME=username
GITHUB_PAT=PAT
```

Note: this is presently linux only, however it may be expanded in the future to cover macos and windows.

# License

GPLv3 Applies to the following
* Makefile
* readme.md
* lib/stdio.fnl

MIT
* src/
* test/
* lib/stdio-nil.lua
* all files in root directory, other than Makefile and readme.md

Other files in lib/ have their own licenses

The `release` make target removes GPLv3 files from the code, so you will not have GPLv3 code in your final build (unless you add it there yourself), meaning that the GPLv3 will not spread to your final build.
