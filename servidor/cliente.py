import asyncio
import websockets

async def conectar_a_servidor():
    uri = "ws://192.168.50.4:8765"
    try:
        async with websockets.connect(uri) as websocket:
            print(f"Conectado al servidor en {uri}")
            
            # Enviar un mensaje al servidor
            mensaje = "¡Hola, servidor!"
            await websocket.send(mensaje)
            print(f"Mensaje enviado: {mensaje}")
            
            # Esperar y recibir la respuesta del servidor
            respuesta = await websocket.recv()
            print(f"Respuesta recibida: {respuesta}")
    
    except Exception as e:
        print(f"Error de conexión: {e}")

# Ejecutar el cliente
asyncio.run(conectar_a_servidor())
