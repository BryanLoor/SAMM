from app.models.SAMM_BitacoraVisita import SAMM_BitacoraVisita, SAMM_BitacoraVisitaSchema
from app.models.SAMM_UbiPersona import SAMM_UbiPersona, SAMM_UbiPersonaSchema
from app.models.SAMM_Ubicacion import SAMM_Ubicacion, SAMM_UbicacionSchema
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema
from app.models.SAMM_Rol import SAMM_Rol, SAMM_RolSchema
from app.models.SAMM_RolUsu import SAMM_RolUsu, SAMM_RolUsuSchema
from flask import jsonify, request
from flask_cors import cross_origin
from app.visitas import bp
from app.extensions import db
from sqlalchemy import text
import base64
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime
from sqlalchemy import or_

@bp.route('/roles', methods=['GET'])
@cross_origin()
@jwt_required()
def getRoles():
    try:
        roles = db.session.query(SAMM_Rol.Id,
                                    SAMM_Rol.Codigo,
                                    SAMM_Rol.Descripcion,
                                    SAMM_Rol.Estado,
                                    SAMM_Rol.FechaCrea,
                                    SAMM_Rol.FechaModifica,
                                    SAMM_Usuario.Codigo.label("CodUsuarioCrea"),
                                   ) \
            .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_Rol.UsuarioCrea) \
            .all()
        rolesSchema = SAMM_RolSchema(many=True)
        return jsonify(roles=rolesSchema.dump(roles)), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@bp.route('/roles/<id>', methods=['GET'])
@cross_origin()
@jwt_required()
def getRol(id):
    try:
        rol = SAMM_Rol.query.filter_by(Id=id).first()
        if rol is None:
            return jsonify({'message': 'Rol no existe'}), 400
        rolSchema = SAMM_RolSchema()
        return jsonify(rol=rolSchema.dump(rol)), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    





@bp.route('/roles', methods=['POST'])
@cross_origin()
@jwt_required()
def addRol():
    try:
        user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
        if user is None:
            return jsonify({'message': 'Usuario no existe'}), 400
        data = request.get_json()
        rol = SAMM_Rol.query.filter_by(Nombre=data['nombre']).first()
        if rol:
            return jsonify({'message': 'Rol ya existe'}), 500

        rol = SAMM_Rol(
            Codigo=data['Codigo'],
            Descripcion=data['descripcion'],
            Estado='A',
            FechaCrea=datetime.now(),
            UsuarioCrea=user.Id,
            FechaModifica=datetime.now(),
            UsuarioModifica=user.Id,
            FechaUltimoLogin=datetime.now(),
        )
        db.session.add(rol)
        db.session.commit()

        return jsonify({'message': 'Rol creado exitosamente'}), 200


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

# ... Código anterior ...

@bp.route('/rolesxusuario', methods=['POST'])
@cross_origin()
@jwt_required()
def get_roles_by_usuario():
    data = request.get_json()

    # Obtener el valor del parámetro "usuario" del cuerpo de la solicitud
    usuario_id = data.get('usuario')

    # Verificar si se proporcionó el parámetro "usuario" en el cuerpo de la solicitud
    if usuario_id is None:
        return jsonify({"error": "Se requiere el parámetro 'usuario' en el cuerpo de la solicitud."}), 400

    # Aquí puedes realizar la lógica para obtener los roles de usuario para el "usuario" dado
    # Ejecutar el query utilizando SQLAlchemy para obtener los roles
    query_result = db.session.query(SAMM_RolUsu.Estado.label('rolusuarioestado'),
                                    SAMM_Rol.Codigo,
                                    SAMM_Rol.Descripcion) \
        .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_RolUsu.IdUsuario) \
        .join(SAMM_Rol, SAMM_Rol.Id == SAMM_RolUsu.IdRol) \
        .filter(SAMM_Usuario.Id == usuario_id) \
        .all()

    # Formatear los resultados como un diccionario de objetos JSON
    roles = [
        {
            'rolusuarioestado': item.rolusuarioestado,
            'Codigo': item.Codigo,
            'Descripcion': item.Descripcion
        }
        for item in query_result
    ]

    return jsonify(roles)



# Crear una instancia del esquema SAMM_RolSchema
rol_schema = SAMM_RolSchema()

@bp.route('/addrol', methods=['POST'])
def add_rol():
    try:

       # Obtener los datos del cuerpo de la solicitud y deserializar usando el esquema
        data = request.get_json()
        codigo = data.get('Codigo')
        descripcion = data.get('Descripcion')
        Idsuario = data.get('IdUsuario')

        # Validar que se proporcionen los campos obligatorios (codigo y descripcion)
        if not codigo or not descripcion:
            return jsonify({"error": "Los campos 'codigo' y 'descripcion' son requeridos."}), 400
        print(data) 
        data['Estado'] = 'A'  # Establecer el Estado como 'A'
        data['UsuarioCrea'] = Idsuario  # Establecer el UsuarioCrea con el ID del usuario logueado
        data['UsuarioModifica'] = Idsuario  # Establecer el UsuarioModifica con el ID del usuario logueado
        data['FechaCrea'] = datetime.now()  # Establecer la FechaCrea con la fecha y hora actual
        data['FechaModifica'] = datetime.now()  # Establecer la FechaModifica con la fecha y hora actual
           
        # Deserializar los datos usando el esquema
        new_rol = rol_schema.load(data)
      
        # Agregar el nuevo rol a la base de datos
        db.session.add(new_rol)
        db.session.commit()

        # Responder con el rol agregado en formato JSON
        return rol_schema.dump(new_rol)
    except Exception as e:
        # Si hay algún error, responder con un mensaje de error y el código de estado 400 (Bad Request)
        return jsonify({"error": str(e)}), 400

# Resto del código...
