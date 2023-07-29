from app.models.SAMM_Persona import Persona, PersonaSchema
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema
from app.models.SAMM_RolUsu import SAMM_RolUsu, SAMM_RolUsuSchema
from app.models.SAMM_Rol import SAMM_Rol, SAMM_RolSchema
from flask import jsonify, request
from flask_cors import cross_origin
from app.visitas import bp
from app.extensions import db
from sqlalchemy import text
import base64
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime
from sqlalchemy import or_


@bp.route('/usuarios', methods=['GET'])
@cross_origin()
@jwt_required()
def getUsuarios():
    try:
        
        usuario_creador_alias = db.aliased(SAMM_Usuario)
        usuario_modificador_alias = db.aliased(SAMM_Usuario)

        # Realizar joins adicionales con los alias para obtener información del usuario creador y modificador
        usuarios = db.session.query(SAMM_Usuario.Id,
                                    SAMM_Usuario.Codigo,
                                    Persona.Nombres,
                                    Persona.Apellidos,
                                    SAMM_Usuario.FechaCrea,
                                    usuario_creador_alias.Codigo.label("CodigoUsCrea"),
                                    SAMM_Usuario.FechaModifica,
                                    usuario_modificador_alias.Codigo.label("CodigoUsMod"),
                                    SAMM_Usuario.Estado
                                   ) \
            .join(Persona, Persona.Id == SAMM_Usuario.IdPersona) \
            .join(usuario_creador_alias, usuario_creador_alias.Id == SAMM_Usuario.UsuarioCrea) \
            .join(usuario_modificador_alias, usuario_modificador_alias.Id == SAMM_Usuario.UsuarioModifica) \
            .all()
            

        # Procesar los resultados del join y convertirlos en una lista de diccionarios
        resultados = []

        for usuario in usuarios:
            resultados.append({
                'id': usuario.Id,
                'codigo': usuario.Codigo,
                'nombres': usuario.Nombres,
                'apellidos': usuario.Apellidos,
                'fechaCrea:':usuario.FechaCrea.strftime('%d-%m-%Y'),
                'horaCrea': usuario.FechaCrea.strftime('%H:%M:%S'),
                'codigo_usuario_crea': usuario.CodigoUsCrea,
                'fechaModifica:':usuario.FechaModifica.strftime('%d-%m-%Y'),
                'horaModifica': usuario.FechaModifica.strftime('%H:%M:%S'),
                'codigo_usuario_modifica': usuario.CodigoUsMod,
                'estado': usuario.Estado
                # Otros campos que desees agregar...
            })
        return jsonify(resultados), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500

@bp.route('/updaterol/<id>', methods=['PUT'])
@cross_origin()
@jwt_required()
def updateRol(id):
    try:
        data = request.get_json()
        rol = SAMM_Rol.query.filter_by(Id=id).first()
        if rol is None:
            return jsonify({'message': 'Rol no existe'}), 400
        rol.Codigo=data['codigo']
        rol.Descripcion=data['descripcion']
        rol.Estado=data['estado']
        db.session.add(rol)
        db.session.commit()
        return jsonify({'message': 'Rol actualizado exitosamente'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@bp.route('/roles/<id>', methods=['DELETE'])
@cross_origin()
@jwt_required()
def deleteRol(id):
    try:
        rol = SAMM_Rol.query.filter_by(Id=id).first()
        if rol is None:
            return jsonify({'message': 'Rol no existe'}), 400
        db.session.delete(rol)
        db.session.commit()
        return jsonify({'message': 'Rol eliminado exitosamente'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500


from flask import request, jsonify


"""" Body
{
    "rol":1
}

"""


"""" Output
[
    {
        "Codigo": "admin",
        "Nombres": "Wilmer Rodriguez",
        "estadousuario": "A",
        "rolusuarioestado": "A"
    }
]
"""


@bp.route('/usuariosxrol', methods=['POST'])
@cross_origin()
@jwt_required()
def get_usuarios_by_rol():
    data = request.get_json()

    # Obtener el valor del parámetro "usuario" del cuerpo de la solicitud
    rol_id = data.get('rol')

    # Verificar si se proporcionó el parámetro "usuario" en el cuerpo de la solicitud
    if rol_id is None:
        return jsonify({"error": "Se requiere el parámetro 'rol' en el cuerpo de la solicitud."}), 400

    # Aquí puedes realizar la lógica para obtener los roles de usuario para el "usuario" dado
    # Ejecutar el query utilizando SQLAlchemy para obtener los roles
    query_result = db.session.query(SAMM_RolUsu.Estado.label('rolusuarioestado'),
                                    SAMM_Usuario.Codigo,
                                    (Persona.Nombres +" "+ Persona.Apellidos).label('nombrescompletos'),
                                    SAMM_Usuario.Estado) \
        .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_RolUsu.IdUsuario) \
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id) \
        .join(SAMM_Rol, SAMM_Rol.Id == SAMM_RolUsu.IdRol) \
        .filter(SAMM_Rol.Id == rol_id) \
        .all()

    # Formatear los resultados como un diccionario de objetos JSON
    usuarios = [
        {
            'rolusuarioestado': item.rolusuarioestado,
            'Codigo': item.Codigo,
            'Nombres': item.nombrescompletos,
            'estadousuario':item.Estado
        }
        for item in query_result
    ]

    return jsonify(usuarios)


@bp.route('/usuarios/<id>', methods=['GET'])
@cross_origin()
@jwt_required()
def getUsuario(id):
    try:
        usuario = SAMM_Usuario.query.filter_by(Id=id).first()
        if usuario is None:
            return jsonify({'message': 'Usuario no existe'}), 400
        usuarioSchema = SAMM_UsuarioSchema()
        #addp persona data
        ubiPersona = Persona.query.filter_by(Id=usuario.IdPersona).first()
        if ubiPersona is None:
            return jsonify({'message': 'Persona no existe'}), 400
        ubiPersonaSchema = PersonaSchema()
        return jsonify(usuario=usuarioSchema.dump(usuario), persona=ubiPersonaSchema.dump(ubiPersona)), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@bp.route('/usuarios', methods=['POST'])
@cross_origin()
@jwt_required()
def addUsuario():
    try:
        user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
        if user is None:
            return jsonify({'message': 'Usuario no existe'}), 400
        data = request.get_json()
        usuario = SAMM_Usuario.query.filter_by(Codigo=data['codigo']).first()
        if usuario:
            return jsonify({'message': 'Usuario ya existe'}), 500

        usuario = SAMM_Usuario(
            Codigo=data['codigo'],
            IdPersona=data['idPersona'],
            Clave=data['clave'],
            Estado='A',
            FechaCrea=datetime.now(),
            UsuarioCrea=user.Id,
            FechaModifica=datetime.now(),
            UsuarioModifica=user.Id,
            IdRol=data['idRol']
        )
        db.session.add(usuario)
        db.session.commit()
        return jsonify({'message': 'Usuario agregado exitosamente'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    

@bp.route('/usuarios/<id>', methods=['PUT'])
@cross_origin()
@jwt_required()
def updateUsuario(id):
    try:
        user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
        if user is None:
            return jsonify({'message': 'Usuario no existe'}), 400
        usuario = SAMM_Usuario.query.filter_by(Id=id).first()
        if usuario is None:
            return jsonify({'message': 'Usuario no existe'}), 400
        data = request.get_json()
        usuario.Codigo=data['codigo'] if data['codigo'] else usuario.Codigo
        usuario.IdPersona=data['idPersona'] if data['idPersona'] else usuario.IdPersona
        usuario.Clave=data['clave'] if data['clave'] else usuario.Clave
        usuario.Estado=data['estado'] if data['estado'] else usuario.Estado
        usuario.FechaModifica=datetime.now()
        usuario.UsuarioModifica=user.Id 
        usuario.IdRol=data['idRol'] if data['idRol'] else usuario.IdRol
        db.session.commit()
        return jsonify({'message': 'Usuario actualizado exitosamente'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@bp.route('/usuarios/<id>', methods=['DELETE'])
@cross_origin()
@jwt_required()
def deleteUsuario(id):
    try:
        usuario = SAMM_Usuario.query.filter_by(Id=id).first()
        if usuario is None:
            return jsonify({'message': 'Usuario no existe'}), 400
        db.session.delete(usuario)
        db.session.commit()
        return jsonify({'message': 'Usuario eliminado exitosamente'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    