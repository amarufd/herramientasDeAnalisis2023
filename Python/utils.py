import pymysql as mysql
from sshtunnel import SSHTunnelForwarder
import pandas as pd
from datetime import datetime
import json


class DatabaseConnection:
    def __init__(self, path_config_file):
        creds = json.load(open( path_config_file , 'r'))

        self.ssh_port = 22
        self.ssh_host = creds['SSH_HOST']
        self.ssh_user = creds['SSH_USER']
        self.ssh_pass = creds['SSH_PASS']

        self.db_port = creds['DB_PORT']
        self.db_ip = 'localhost'
        self.db_user = creds['DB_USER']
        self.db_pass = creds['DB_PASS']
        self.db_name = creds['DB_NAME']

        self.conn = None
        self.cur = None
        self.ssh_tunnel = None

    def connect(self):
        print("Iniciando Tunnel")
        self.ssh_tunnel =  SSHTunnelForwarder(
                (self.ssh_host,self.ssh_port),
                ssh_username=self.ssh_user,
                ssh_password=self.ssh_pass,
                allow_agent=False,
                remote_bind_address=(self.db_ip, self.db_port))
        self.ssh_tunnel.start()

        try:
            print("Iniciando conneccion con bd")
            self.conn = mysql.connect(
                    host='localhost',
                    port=self.ssh_tunnel.local_bind_port,
                    user=self.db_user,
                    password=self.db_pass,
                    database=self.db_name)
            self.cur = self.conn.cursor()
            print("Conección exitosa")
        except Exception as e:
            print(e)

    def disconnect(self):
        if self.conn:
            self.conn.close()
            self.ssh_tunnel.close
            print("Desconectado exitosamente")

    def execute_query(self, query):
        try:
            if self.conn:
                return pd.read_sql_query(query,self.conn)
            else:
                print("Falta coneccion con la base de datos")
        except Exception as error:
            print("Error al ejecutar la consulta:", error)

    '''def fetch_data(self, query):
        try:
            self.cursor.execute(query)
            rows = self.cursor.fetchall()
            return rows
        except sqlite3.Error as error:
            print("Error al obtener los datos:", error)
            return None'''


def str2date(texto_fecha):
    fecha = None
    try:
        fecha = datetime.strptime(texto_fecha, '%Y-%m-%d')
    except:
        try:
            fecha = datetime.strptime(texto_fecha, '%Y-%m-%d %H:%M')
        except:
            try:
                fecha = datetime.strptime(texto_fecha, '%Y-%m-%dT%H:%M')
            except Exception as e:
                print("Error: " + str(e))
    return fecha