from app.rondas import bp
from flask_cors import cross_origin
from app.models.SAMM_Persona import Persona
from flask import jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.extensions import db

from app.models.SAMM_BitacoraRecorrido import SAMM_BitacoraRecorrido
from app.models.SAMM_Usuario import SAMM_Usuario
from app.models.SAMM_Ronda import SAMM_Ronda



@bp.route('/getBitacoraRecorrido', methods=['GET'])
@cross_origin()
@jwt_required()
def getBitacoraRecorrido():
    #idUbicacion = request.json["idUbicacion"]
    
    query = (
        db.session.query(SAMM_Usuario,Persona,SAMM_BitacoraRecorrido)
        .join(SAMM_Ronda, SAMM_Ronda.Id == SAMM_BitacoraRecorrido.IdRonda)
        .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraRecorrido.IdAgente)
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
        .all()
        )
    print(query)
    schema = [
    {
        "IdUsuario": q.SAMM_Usuario.Id,
        "idRonda": q.SAMM_Ronda.Id,
        "Nombres": f"{q.Persona.Nombres} {q.Persona.Apellidos}" if q.Persona else None,
    }
    for q in query
]
    return jsonify({"total":len(schema),"data":schema}), 200