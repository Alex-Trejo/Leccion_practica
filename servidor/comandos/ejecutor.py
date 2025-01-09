import os

def ejecutar_comando(comando):
    if comando == "abrir_word":
        os.system("start winword")  # Abre Microsoft Word
    elif comando == "abrir_excel":
        os.system("start excel")  # Abre Microsoft Excel
    elif comando == "reproducir_musica":
        os.system("start wmplayer")  # Abre Windows Media Player
    else:
        print(f"Comando no reconocido: {comando}")
