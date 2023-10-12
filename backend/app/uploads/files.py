from flask import jsonify, request
from flask_cors import cross_origin
from werkzeug.utils import secure_filename
import os
from flask import send_from_directory
# from app import config
# from backend.app import app
from flask_cors import cross_origin



from app.uploads import bp

@bp.route('/cargar_imagen', methods=['POST'])
@cross_origin()
# @jwt_required()
def cargar_imagen ():
    basedir = os.path.abspath(os.path.dirname(__file__))
    dire = os.path.join(basedir, '..','statics')
    # print(basedir)
    # print("fffff")
    # return jsonify(basedir), 200
    if 'archivo' not in request.files:
        return 'No se ha proporcionado ningún archivo', 400

    archivo = request.files['archivo']

    if archivo.filename == '':
        return 'No se ha seleccionado un archivo', 400

    if archivo:
        # Asegúrate de que el nombre del archivo sea seguro
        nombre_seguro = secure_filename(archivo.filename)

        # Guarda el archivo en el directorio de almacenamiento
        archivo.save(os.path.join(dire, nombre_seguro))
        # archivo.save(os.path.join(basedir, nombre_seguro))

        return 'Archivo cargado con éxito'



@bp.route('/archivos/<nombre_archivo>', methods=['GET'])
@cross_origin()
# @jwt_required()
def servir_archivo(nombre_archivo):
    basedir = os.path.abspath(os.path.dirname(__file__))
    dire = os.path.join(basedir, '..','statics')
    return send_from_directory(dire, nombre_archivo)
    # return send_from_directory(basedir, nombre_archivo)
