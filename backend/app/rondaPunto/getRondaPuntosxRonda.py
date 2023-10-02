from flask import jsonify, request
from flask_cors import cross_origin
from app.rondaPunto import bp
from app.extensions import db
from sqlalchemy import text
import base64
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime, timedelta
import time
from sqlalchemy import or_

from app.models.SAMM_UbiUsuario import SAMM_UbiUsuario,SAMM_UbiUsuarioSchema
from app.models.SAMM_Ubicacion import SAMM_Ubicacion,SAMM_UbicacionSchema
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema
from app.models.SAMM_Persona import Persona
from app.models.SAMM_BitacoraVisita import SAMM_BitacoraVisita
from app.models.SAMM_Estaddos import SAMM_Estados

from app.models.SAMM_Ronda import SAMM_Ronda
from app.models.SAMM_Ronda_Punto import SAMM_Ronda_Punto

#obtener los puntos de una ronda por su id
@bp.route('/getRondaPuntosxRonda/<int:idRonda>', methods=['GET'])
@cross_origin()
@jwt_required()
def getRondaPuntosxRonda(idRonda):

    query = (
        db.session.query(SAMM_Ronda_Punto,SAMM_Ronda, Persona,SAMM_Estados)
        .join(SAMM_Ronda, SAMM_Ronda.Id == SAMM_Ronda_Punto.IdRonda)
        .join(SAMM_Usuario, SAMM_Ronda_Punto.UsuModifica == SAMM_Usuario.Id, isouter=True)
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id, isouter=True)
        .join(SAMM_Estados, SAMM_Ronda_Punto.Estado == SAMM_Estados.Id)
        .filter(SAMM_Ronda_Punto.IdRonda == idRonda)
        .all()
    )

    schema = [
        {
        "Id" :q.SAMM_Ronda_Punto.Id,
        "IdRonda" : q.SAMM_Ronda_Punto.IdRonda,
        "Orden" : q.SAMM_Ronda_Punto.Orden,
        "Coordenada" : q.SAMM_Ronda_Punto.Coordenada,
        "Descripcion": q.SAMM_Ronda_Punto.Descripcion,
        "Estado" : q.SAMM_Ronda_Punto.Estado,
        "NameEstado" : q.SAMM_Estados.Descripcion,   
        "FechaCreacion" : q.SAMM_Ronda_Punto.FechaCreacion,
        "UsuCreacion": q.SAMM_Ronda_Punto.UsuCreacion,
        "FechaModificacion" : q.SAMM_Ronda_Punto.FechaModificacion,
        "UsuModifica": q.SAMM_Ronda_Punto.UsuModifica,
        "NameUsuModifica":f"{q.Persona.Nombres} {q.Persona.Apellidos}" if q.Persona else None

        }
        for q in query
    ]
    return jsonify({"data":schema}),200