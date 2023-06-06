# Esto es un comentario

'''
Desarrollador: Amaru Fernandez
Ubicacion: santiago
Version python: 3.8
'''

import random

######################################## PRIMERA PARTE

n = 50  # Longitud deseada de la lista
elementos = ["bueno", "malo", "mas o menos"]  # Elementos posibles

huevos = [random.choice(elementos) for _ in range(n)]
hist_huevos_cambiados = list()
huevos_buenos = 0
huevos_malos = 0
huevos_otros = 0
for posicion_huevo in range(0, len(huevos)):
    if huevos[posicion_huevo] == 'malo':
        huevos_malos += 1
    elif huevos[posicion_huevo] == 'bueno':
        huevos_buenos += 1
    else:
        huevos_otros += 1
    
    if huevos[posicion_huevo] == 'malo' or huevos[posicion_huevo] != 'bueno':
        # print("Se cambia el huevo porque salio "+ huevos[posicion_huevo])
        huevos[posicion_huevo] = "bueno"
        hist_huevos_cambiados.append(posicion_huevo)


print("hay {} huevos buenos, {} huevos malos y {} huevos indefinidos".format(huevos_buenos,huevos_malos,huevos_otros))
print(f"se cambiaron los huevos: {hist_huevos_cambiados}")

print(huevos)