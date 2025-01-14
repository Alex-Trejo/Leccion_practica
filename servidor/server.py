import asyncio
import websockets
import os

# Función para ejecutar comandos
def ejecutar_comando(comando):
    if comando == "abrir_word":
        os.system("start winword")  # Abre Microsoft Word
        return "Microsoft Word abierto."
    elif comando == "abrir_excel":
        os.system("start excel")  # Abre Microsoft Excel
        return "Microsoft Excel abierto."
    elif comando == "abrir_navegador":
        os.system("start chrome") # Abre un navegador
        return "Navegador Chrome abierto."
    else:
        return f"Comando no reconocido: {comando}"

# Cambiar la firma de la función a solo recibir websocket
async def manejar_conexion(websocket):
    print(f"Conexión establecida con {websocket.remote_address}")
    try:
        async for mensaje in websocket:
            print(f"Mensaje recibido: {mensaje}")
            # Ejecutar el comando recibido
            respuesta = ejecutar_comando(mensaje)
            # Enviar la respuesta de vuelta al cliente
            await websocket.send(respuesta)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        print(f"Conexión cerrada con {websocket.remote_address}")

async def iniciar_servidor():
    # Solo pasas la función de manejo sin path
    servidor = await websockets.serve(manejar_conexion, "192.168.50.4", 8765)
    print("Iniciando servidor en ws://192.168.50.4:8765")
    await servidor.wait_closed()

# Ejecutar el servidor
asyncio.run(iniciar_servidor())
