FROM ubuntu:latest

# Update packages
RUN apt update && apt install -y \
    bat \
    cmake \
    curl \
    fd-find \
    g++ \
    git \
    htop \
    make \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    tar \
    unzip \
    unzip \
    wget \
 && rm -rf /var/lib/apt/lists/*

# Create User
RUN useradd apigeon -m
USER apigeon

# Set Work Directory
WORKDIR /home/apigeon

# Instal fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
 && ~/.fzf/install --all

# Install latest Neovim
RUN mkdir -p $HOME/.local/bin/ && cd $HOME/.local/bin \
 && wget -q "https://github.com/neovim/neovim/releases/download/v0.9.4/nvim.appimage" -O nvim.appimage && chmod u+x nvim.appimage \
 && ./nvim.appimage --appimage-extract && ln -s squashfs-root/AppRun nvim \
 && rm -f nvim.appimage


# Get nvm node manager for LSP
SHELL ["/bin/bash", "-c"]
RUN wget -q -O - "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash \
 && . $HOME/.nvm/nvm.sh && nvm install node
RUN echo 'export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> .bashrc

# Sync Lazy plugins
RUN git clone https://github.com/apigeon/.dotfiles.git \
    && mkdir -p $HOME/.config/ \
    && ln -s $HOME/.dotfiles/.config/nvim $HOME/.config/nvim \
    && ~/.local/bin/nvim --headless -c 'autocmd User LazySync quitall' -c 'Lazy sync'

#ENTRYPOINT ~/.local/bin/nvim
