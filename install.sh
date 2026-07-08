#!/bin/bash

echo "🦙 Configurazione dell'Ollama Panic Button..."

# 1. Crea le cartelle necessarie
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/applications

# 2. Copia l'icona
cp assets/ollama-restart.png ~/.local/share/icons/ollama-restart.png

# 3. Crea il file .desktop in modo dinamico usando l'utente corrente
USER_HOME=$HOME
cat <<EOF > ~/.local/share/applications/restart-ollama.desktop
[Desktop Entry]
Type=Application
Name=Restart Ollama
Comment=Riavvia il servizio Ollama al volo
Exec=sudo systemctl restart ollama
Icon=$USER_HOME/.local/share/icons/ollama-restart.png
Terminal=false
Categories=Utility;Development;
EOF

# 4. Configura sudoers (richiede una volta sola la password durante l'installazione)
echo "🔒 Configurazione dei permessi speciali per systemctl..."
sudo CURRENT_USER=$USER bash -c 'echo "$CURRENT_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart ollama" >> /etc/sudoers.d/ollama-panic-button'

# 5. Rinfresca la cache grafica
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    touch ~/.local/share/applications/restart-ollama.desktop
fi

echo "✅ Installazione completata! Cerca 'Restart Ollama' tra le tue applicazioni e aggiungilo ai preferiti."
