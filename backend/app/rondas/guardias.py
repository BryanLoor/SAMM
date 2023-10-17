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
