FROM archlinux
RUN printf '\n[archlinuxcn]\nServer = https://repo.archlinuxcn.org/$arch\n' | tee -a /etc/pacman.conf
RUN pacman-key --init && pacman-key --populate && pacman -Syyu --noconfirm archlinuxcn-keyring 
RUN pacman -S --noconfirm pikaur base-devel cmake ninja clang gdb lldb iverilog fish python nano vim emacs-nox && pacman -Sc --noconfirm

RUN useradd -m csc3050 && \
	echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "csc3050 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
	echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
	locale-gen

ENV LANG=en_US.utf8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8
RUN sudo -u csc3050 pikaur -S --noconfirm --color=always code-server && \
    pacman -Sc --noconfirm
RUN  chsh -s /usr/bin/fish csc3050

EXPOSE 3050

ENV PASSWORD=csc3050

USER csc3050

CMD ["code-server", "--bind-addr", "0.0.0.0:3050", "--auth", "password"]

