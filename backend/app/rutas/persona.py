from app.models.SAMM_BitacoraVisita import SAMM_BitacoraVisita, SAMM_BitacoraVisitaSchema
from app.models.SAMM_UbiPersona import SAMM_UbiPersona, SAMM_UbiPersonaSchema
from app.models.SAMM_Ubicacion import SAMM_Ubicacion, SAMM_UbicacionSchema
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema
from app.models.SAMM_Persona import Persona, PersonaSchema
from app.models.SAMM_Rol import SAMM_Rol
from flask import jsonify, request
from flask_cors import cross_origin
from app.rutas import bp
from app.extensions import db
from sqlalchemy import text
import base64
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime
from sqlalchemy import or_


persona_schema = PersonaSchema()
personas_schema = PersonaSchema(many=True)

#Obtiene todos los registros de la tabla Persona
@bp.route('/personas', methods=['GET'])
@cross_origin()
@jwt_required()
def getPersonas():
    try:
        todas_personas = Persona.query.all()
        
        results =  personas_schema.dump(todas_personas)
        return jsonify(results), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500

#Consulta registro Persona por ID

# API para consultar por ID
@bp.route('/personas/<int:id>', methods=['GET'])
@cross_origin()
@jwt_required()
def get_persona(id):
    try:
        persona = Persona.query.get(id)
        return persona_schema.jsonify(persona)
    except Exception as e:
        return jsonify({'message': str(e)}), 500

@bp.route('/buscarPersonaXIden/<cedula>', methods=['GET'])	
@cross_origin()
@jwt_required()
def existePersona(cedula):
    try:
        persona = Persona.query.filter_by(Identificacion=cedula).first()
        if persona is None:
            return jsonify({'message': 'Persona no existe'}), 400
        return jsonify(persona=persona.serialize()), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    

    
    

@bp.route('/lista', methods=['GET'])
@cross_origin()
@jwt_required()
def getVisitas():
    try:
        visitas = SAMM_BitacoraVisita.query.all()
        #use squema to serialize
        visita_schema = SAMM_BitacoraVisitaSchema(many=True)
        return jsonify(visita_schema.dump(visitas)), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    

@bp.route('/personas/<rol>', methods=['GET'])
@cross_origin()
@jwt_required()
def getPersonasByRol(rol):
    try:
        # make a dict of estado
        if(rol == 'Guardia' or rol == 'Agente'):
            estados = {'A': 'En Guardia', 'I': 'Desvinculado', 'D': 'En descanso', 'L': 'Licencia', 'P': 'Día Libre'}
        else:
            estados = {'A': 'Activo', 'I': 'Inactivo'}
        #rol being a string get the id from the table, being equal no matter the case
        rol=rol.upper()
        rol = SAMM_Rol.query.filter_by(Codigo=rol).first()
        personas = Persona.query.filter_by(IdRol=rol.Id).all()

        # only return foto, Nombres Apellidos, Id, Identificacion, Cel_Personal, Estado
        result = []
        for persona in personas:
            print(persona.Estado)
            estadoT=persona.Estado if persona.Estado in estados else 'A'
            print(estados[estadoT])
            result.append(
                {
                    'id': persona.Id,
                    'nombres': persona.Nombres + ' ' + persona.Apellidos,
                    'cedula': persona.Identificacion,
                    'estado': estados[estadoT],
                    'tel_celular': persona.Cel_Personal,
                    'tel_convencional': persona.Tel_Domicilio,
                    'email': persona.Correo_Domicilio,
                    'direccion': persona.Dir_Domicilio,
                    'fecha_nacimiento': persona.FechaNac,
                    'genero': persona.Sexo,
                    'cargo': persona.Cargo,
                }
            )
        return jsonify(personas=result), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@bp.route('/personasRol', methods=['POST'])
@cross_origin()
@jwt_required()
def getPersonasRol():
    #get data from request
    data = request.get_json()
    #get rol from data
    rol = data['rol']
    #get personas from rol
    personas = SAMM_Usuario.query.filter_by(IdPerfil=rol).all()
    result = []
    for usuario in personas:
        #get persona from usuario
        persona = Persona.query.filter_by(Id=usuario.IdPersona).first()
        result.append(
            {
                'tipo': usuario.IdPerfil,
                'id': persona.Id,
                'nombre': persona.Nombres,
                'apellido': persona.Apellidos,
                'cedula': persona.Identificacion,
                'estado': usuario.Estado,
                'usuario': usuario.Codigo,
                'tel_celular': persona.Cel_Personal,
                'tel_convencional': persona.Tel_Domicilio,
                'email': persona.Correo_Domicilio,
                'direccion': persona.Dir_Domicilio,
                'fecha_nacimiento': persona.FechaNac,
                'genero': persona.Sexo,
                'cargo': persona.Cargo,
            
            }
        )
    return jsonify(result), 200


@bp.route('/crearPersona', methods=['POST'])
@cross_origin()
@jwt_required()
def addPersona():
    #get data from request
    data = request.get_json()
    #get user from jwt
    user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
    if user is None:
        return jsonify({'message': 'Usuario no existe'}), 400
    #check if there is a persona with the same cedula
    persona = Persona.query.filter_by(Identificacion=data['identificacion']).first()
    if persona:
        return jsonify({'message': 'Persona ya existe'}), 500
    # #check if there is a persona with the same email
    # persona = Persona.query.filter_by(Correo_Domicilio=data['correo']).first()
    # if persona:
    #     return jsonify({'message': 'Correo ya existe'}), 500
    
    #create a new persona
    persona = Persona(
        TipoIde =data['tipoIde'],
        Identificacion=data['identificacion'],
        Nombres=data['nombres'],
        Apellidos=data['apellidos'],
        EstadoCivil=data['estadoCivil'],
        Sexo=data['sexo'],
        Cel_Personal=data['cel_personal'],
        Cel_Trabajo=data['cel_trabajo'],
        Dir_Domicilio=data['dir_domicilio'],
        Dir_Trabajo=data['dir_trabajo'],
        Correo_Personal=data['correo_personal'],
        Correo_Trabajo=data['correo_trabajo'],
        Estado='A',
        FechaCrea=datetime.now(),
        UsuarioCrea=user.Id,
        FechaModifica=datetime.now(),
        UsuarioModifica=user.Id,
        # Foto=None,
        # NombreFoto=None,
        # Mimetype=None,
    )
    db.session.add(persona)
    db.session.commit()
    # no new user
    return jsonify({'message': 'Persona creada con éxito'}), 201