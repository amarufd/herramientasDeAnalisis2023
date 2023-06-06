from utils import DatabaseConnection
import matplotlib.pyplot as plt

path = ''
conn = DatabaseConnection(path + "cred_db.json")

conn.connect()

query="""
SELECT PRECIO, PRODUCTO
FROM PRODUCTOS
"""

response = conn.execute_query(query)

response.plot.bar(y="PRECIO", x = "PRODUCTO")
plt.title('Grafico de Barras')
plt.xlabel('Nombre Producto')
plt.ylabel('Precio')
plt.grid(True)

plt.savefig( path + "barras.png" )



conn.disconnect()

