FROM archlinux
RUN printf '\n[archlinuxcn]\nServer = https://repo.archlinuxcn.org/$arch\n' | tee -a /etc/pacman.conf
RUN pacman-key --init && pacman-key --populate && yes | pacman -Syyu --noconfirm archlinuxcn-keyring && pacman -Sc
RUN pacman -S --noconfirm pikaur base-devel cmake ninja clang gdb lldb iverilog fish python nano vim emacs-nox ctags && pacman -Sc --noconfirm

RUN useradd -m csc3050 && \
	echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "csc3050 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
	echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
	locale-gen

ENV LANG=en_US.utf8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8

RUN sudo -u csc3050 env HTTP_PROXY="$HTTP_PROXY" HTTPS_PROXY="$HTTPS_PROXY" pikaur -Sy --noconfirm --color=always wget code-server && \
    sudo -u csc3050 pikaur -Sc --noconfirm

RUN pushd /tmp && wget $(curl -s https://api.github.com/repos/microsoft/vscode-cpptools/releases/latest \
    | grep "https://.*cpptools-linux.vsix" \
    | cut -d '"' -f 4) && \
    sudo -u csc3050 code-server --install-extension /tmp/cpptools-linux.vsix && \
    rm /tmp/cpptools-linux.vsix && \
    popd

RUN sudo -u csc3050 env code-server --install-extension ms-vscode.cmake-tools && \
    sudo -u csc3050 env code-server --install-extension mshr-h.veriloghdl

RUN chsh -s /usr/bin/fish csc3050
EXPOSE 3050
ENV PASSWORD=csc3050 SHELL=/usr/bin/fish
USER csc3050
RUN curl -kL https://get.oh-my.fish | fish
CMD code-server --bind-addr 0.0.0.0:3050 --auth password

