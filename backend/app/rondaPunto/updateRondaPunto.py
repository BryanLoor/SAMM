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
@bp.route('/updateRondaPunto', methods=['POST'])
@cross_origin()
@jwt_required()
def updateRondaPunto():

    currentUserID =  get_jwt_identity() #CODIGO usuario
    idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo== currentUserID).first()

    idPuntoRonda = request.json['IdPuntoRonda']

    rondaPunto = db.session.query(SAMM_Ronda_Punto).filter(SAMM_Ronda_Punto.Id == idPuntoRonda).first()


    rondaPunto.Orden = request.json['Orden']
    rondaPunto.Coordenada = request.json['Coordenada']
    rondaPunto.Descripcion = request.json['Descripcion']
    rondaPunto.Estado = 0
    rondaPunto.UsuModifica = idUsuario[0]
    rondaPunto.FechaModificacion = datetime.now()

    db.session.add(rondaPunto)
    db.session.commit()


    return jsonify({"msg":"PuntoRonda editada"}), 201

# {
#     "IdRonda": 1,
#     "IdPuntoRonda": 1,
#     "Orden": 1,
#     "Coordenada": "string",
#     "Descripcion": "string"
# }