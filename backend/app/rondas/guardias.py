from datetime import datetime
from sqlalchemy import and_
from flask_jwt_extended import jwt_required, get_jwt_identity
from flask import jsonify, request
from flask_cors import cross_origin
from app.rondas import bp
from app.extensions import db

from app.models.SAMM_Usuario import SAMM_Usuario,SAMM_UsuarioSchema
from app.models.SAMM_UbiUsuario import SAMM_UbiUsuario
from app.models.SAMM_RolUsu import SAMM_RolUsu
from app.models.SAMM_Persona import Persona
from app.models.SAMM_Ronda_Usuario import SAMM_Ronda_Usuario
from app.models.SAMM_Ronda import SAMM_Ronda



@bp.route('/getGuardiasValidos', methods=['POST'])
@cross_origin()
@jwt_required()
def getAllRondasPorUsuario():
    idUbicacion = request.json["idUbicacion"]
    
    query = (
        db.session.query(SAMM_Usuario,SAMM_UbiUsuario,SAMM_RolUsu,Persona)
        .join(SAMM_Usuario, SAMM_UbiUsuario.IdUsuario == SAMM_Usuario.Id)
        .join(SAMM_RolUsu,SAMM_RolUsu.IdUsuario == SAMM_Usuario.Id)
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
        .filter(
                SAMM_UbiUsuario.IdUbicacion==idUbicacion,
                SAMM_Usuario.Estado =="A",
                SAMM_RolUsu.IdRol==5
            
            )
        .all()
        )
    print(query)
    schema = [
    {
        "IdUsuario": q.SAMM_Usuario.Id,
        "idUbicacion": q.SAMM_UbiUsuario.IdUbicacion,
        "Nombres": f"{q.Persona.Nombres} {q.Persona.Apellidos}" if q.Persona else None,
        
    }
    for q in query
]
    
    
    
    return jsonify({"total":len(schema),"data":schema}), 200

@bp.route('/guardarGuardiasPorRonda', methods=['POST'])
@cross_origin()
@jwt_required()
def guardarGuardiasPorRonda():
    user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
    if(user.Id is None): return jsonify({"message":"Usuario  no existe"}),400
    

    data = request.get_json()
    idRonda = data["idRonda"]
    idAgente = data["idAgente"]
    
    usuario_existe = SAMM_Usuario.query.filter(SAMM_Usuario.Id == idAgente).first()
    ronda_existe = SAMM_Ronda.query.filter(SAMM_Ronda.Id == idRonda).first()
    if (usuario_existe is None):
        return jsonify({"message":"Usuario Agente no existe"}),400
    if (ronda_existe is None):
        return jsonify({"message":"Ronda no existe"}),400
    
    
    ronda_usuario_existente=SAMM_Ronda_Usuario.query.filter(
        SAMM_Ronda_Usuario.IdUsuario==idAgente,
        SAMM_Ronda_Usuario.IdRonda==idRonda
    ).first()
    if ronda_usuario_existente:
        return jsonify({"message":"Ronda y usuario existente, no puede crear un registro repetido"}),500
    
    
    
    ronda_usuario = SAMM_Ronda_Usuario()
    ronda_usuario.Estado = "A"
    ronda_usuario.IdRonda = idRonda
    ronda_usuario.IdUsuario = idAgente
    ronda_usuario.FechaCrea = datetime.now() 
    ronda_usuario.FechaMod = datetime.now() 
    ronda_usuario.UsuCrea = user.Id
    ronda_usuario.UsuMod = user.Id
    
    db.session.add(ronda_usuario)
    db.session.commit()
    return jsonify({
            "message":"Ronda creada",
            "IdRonda": ronda_usuario.Id
            }), 201
    


@bp.route('/eliminarRondaUsuario', methods=['DELETE'])
@cross_origin()
@jwt_required()
def eliminarRondaUsuario():
    data = request.get_json()
    idRonda = data["idRonda"]
    idAgente = data["idAgente"]

    try:
        ronda_usuario = SAMM_Ronda_Usuario.query.filter(
            SAMM_Ronda_Usuario.IdUsuario == idAgente,
            SAMM_Ronda_Usuario.IdRonda == idRonda
            ).first()
        if ronda_usuario is None:
            return jsonify({'message': 'Ronda asignada a Agente no existe'}), 400
        db.session.delete(ronda_usuario)
        db.session.commit()
        return jsonify({'message': 'Ronda asignada a Agente eliminado exitosamente'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500


@bp.route('/actualizarRondaUsuario', methods=['PUT'])
@cross_origin()
@jwt_required()
def actualizarRondaUsuario():
    
    try:
        dataRondaUsuario = request.get_json()
        print(dataRondaUsuario)
        user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
        if(user.Id is None): return jsonify({"message":"Usuario  no existe"}),400
        
        ronda_usuario = SAMM_Ronda_Usuario.query.filter(
            SAMM_Ronda_Usuario.IdUsuario == dataRondaUsuario["idAgente"],
            SAMM_Ronda_Usuario.IdRonda == dataRondaUsuario["idRonda"]
            ).first()
        if ronda_usuario is None:
            return jsonify({'message': 'Ronda asignada a Agente no existe'}), 400
        ronda_usuario = SAMM_Ronda_Usuario.query.filter(
            SAMM_Usuario.Id == dataRondaUsuario["idNuevoAgente"],
            SAMM_Ronda.Id == dataRondaUsuario["idNuevoRonda"]
            ).first()
        if ronda_usuario is None:
            return jsonify({'message': 'Los datos a actualizar no son correctos, no existe ronda o agente'}), 400
        
        ronda_usuario.IdRonda = dataRondaUsuario["idNuevoRonda"]
        ronda_usuario.IdUsuario = dataRondaUsuario["idNuevoAgente"]
        ronda_usuario.Estado = dataRondaUsuario["estado"]
        ronda_usuario.FechaMod = datetime.now()
        ronda_usuario.UsuMod = user.Id
        
        db.session.commit()

        return jsonify({'message': 'Ronda asignada a Agente actualizada exitosamente'}), 200


    except Exception as e:
        return jsonify({'message': str(e)}), 500

    pass