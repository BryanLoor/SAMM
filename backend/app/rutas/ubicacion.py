from flask import jsonify, request
from flask_cors import cross_origin
from app.rutas import bp
from app.extensions import db
from sqlalchemy import text
from flask_jwt_extended import jwt_required, get_jwt_identity
from sqlalchemy import or_
from app.models.SAMM_Usuario import SAMM_Usuario
from app.models.SAMM_Ubicacion import SAMM_Ubicacion


# Consultar todos los registros

@bp.route('/getUbicaciones', methods=['GET'])
@cross_origin()
@jwt_required()
def getUbicaciones():
    try:
        # Definir una función para procesar los resultados del join
        def procesar_resultados(ubicaciones):
            resultados = []
            for ubicacion in ubicaciones:
                resultados.append({
                    'id': ubicacion.Id,
                    'codigo': ubicacion.Codigo,
                    'tipo': ubicacion.Tipo,
                    'descripcion': ubicacion.Descripcion,
                    'fecha_crea': ubicacion.FechaCrea.strftime('%d-%m-%Y'),
                    'hora_crea': ubicacion.FechaCrea.strftime('%H:%M:%S'),
                    'codigo_usuario_crea': ubicacion.CodigoUsCrea,
                    'fecha_modifica': ubicacion.FechaModifica.strftime('%d-%m-%Y'),
                    'hora_modifica': ubicacion.FechaModifica.strftime('%H:%M:%S'),
                    'codigo_usuario_modifica': ubicacion.CodigoUsMod,
                    'estado': ubicacion.Estado
                })
            return resultados
        
        usuario_creador_alias = db.aliased(SAMM_Usuario)
        usuario_modificador_alias = db.aliased(SAMM_Usuario)

        # Realizar el join
        ubicaciones = db.session.query(SAMM_Ubicacion.Id,
                                    SAMM_Ubicacion.Codigo,
                                    SAMM_Ubicacion.Tipo,
                                    SAMM_Ubicacion.Descripcion,
                                    SAMM_Ubicacion.FechaCrea,
                                    usuario_creador_alias.Codigo.label("CodigoUsCrea"),
                                    SAMM_Ubicacion.FechaModifica,
                                    usuario_modificador_alias.Codigo.label("CodigoUsMod"),
                                    SAMM_Ubicacion.Estado
                                   ) \
            .join(usuario_creador_alias, SAMM_Ubicacion.UsuarioCrea == usuario_creador_alias.Id) \
            .join(usuario_modificador_alias, SAMM_Ubicacion.UsuarioModifica == usuario_modificador_alias.Id) \
            .all()

        # Procesar los resultados
        resultados = procesar_resultados(ubicaciones)

        return jsonify(resultados), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500

    


# Consultar un registro por id

@bp.route('/getUbicacionXid/<int:id>', methods=['GET'])
@cross_origin()
@jwt_required()
def getUbicacion(id):
    try:
        usuario_creador_alias = db.aliased(SAMM_Usuario)
        usuario_modificador_alias = db.aliased(SAMM_Usuario)

        # Realizar el join
        ubicacion = db.session.query(SAMM_Ubicacion.Id,
                                    SAMM_Ubicacion.Codigo,
                                    SAMM_Ubicacion.Tipo,
                                    SAMM_Ubicacion.Descripcion,
                                    SAMM_Ubicacion.FechaCrea,
                                    usuario_creador_alias.Codigo.label("CodigoUsCrea"),
                                    SAMM_Ubicacion.FechaModifica,
                                    usuario_modificador_alias.Codigo.label("CodigoUsMod"),
                                    SAMM_Ubicacion.Estado
                                   ) \
            .join(usuario_creador_alias, SAMM_Ubicacion.UsuarioCrea == usuario_creador_alias.Id) \
            .join(usuario_modificador_alias, SAMM_Ubicacion.UsuarioModifica == usuario_modificador_alias.Id) \
            .filter(SAMM_Ubicacion.Id == id) \
            .first()

        if ubicacion is None:
            return jsonify({'message': 'Ubicación no encontrada'}), 404

        # Procesar los resultados
        resultados = {
            'id': ubicacion.Id,
            'codigo': ubicacion.Codigo,
            'tipo': ubicacion.Tipo,
            'descripcion': ubicacion.Descripcion,
            'fecha_crea': ubicacion.FechaCrea.strftime('%d-%m-%Y'),
            'hora_crea': ubicacion.FechaCrea.strftime('%H:%M:%S'),
            'codigo_usuario_crea': ubicacion.CodigoUsCrea,
            'fecha_modifica': ubicacion.FechaModifica.strftime('%d-%m-%Y'),
            'hora_modifica': ubicacion.FechaModifica.strftime('%H:%M:%S'),
            'codigo_usuario_modifica': ubicacion.CodigoUsMod,
            'estado': ubicacion.Estado
        }

        return jsonify(resultados), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500