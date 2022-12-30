all: install doom tag

install:
	sudo -v
	./prepare
	time makepkg -si --noconfirm

doom:
	rm -rf ~/.config/emacs/.local/straight/build-$$(emacs --batch --eval "(princ emacs-version)")/straight/
	doom build -r

tag:
	./tag-pkg-tar *$$(uname -m).pkg.zst
