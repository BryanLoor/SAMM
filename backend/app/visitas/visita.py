from flask import jsonify, request
from flask_cors import cross_origin
from app.visitas import bp
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

# @bp.route('/prueba', methods=['POST'])
# @cross_origin()
# @jwt_required()
# def prueba():
#     nuevo = db.session.query(SAMM_UbiUsuario).filter(SAMM_UbiUsuario.Id==24).first()

#     d = "a"
#     dt = datetime.now()
#     print([d,dt])

#     nuevo.FechaModifica = datetime.now()
#     nuevo.FechaTimeModifica = datetime.now()
    
#     print([nuevo.FechaCrea])


    
    

#     db.session.commit()

    

#     s = SAMM_UbiUsuarioSchema()
#     result = s.dump(nuevo)

#     # print(result)


#     return jsonify(result),200

# Obtener las ubicaciones de usuarios que son anfitriones
@bp.route('/getUbicaciones', methods=['GET'])
@cross_origin()
@jwt_required()
def getUbicaciones():
    codigoUsuario = get_jwt_identity()

    query = (
        db.session.query(SAMM_Ubicacion)
        .join(SAMM_UbiUsuario, SAMM_Ubicacion.Id == SAMM_UbiUsuario.IdUbicacion)
        .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_UbiUsuario.IdUsuario)
        .filter(SAMM_Usuario.Codigo == codigoUsuario, SAMM_UbiUsuario.EsAnfitrion == True, SAMM_Ubicacion.Estado == "A")
        .all()
    )

    schema= [
        {
            'Id': q.Id,
            'Codigo' : q.Codigo,
            'Coordenadas': q.Coordenadas,
            'Tipo' : q.Tipo,
            'FechaCrea' :q.FechaCrea,
            'UsuarioCrea' : q.UsuarioCrea,
            'FechaModifica' :q.FechaModifica,
            'Descripcion' : q.Descripcion,
            'UsuarioModifica': q.UsuarioModifica,
            'Direccion' : q.Direccion,
            'Estado' : q.Estado

        }
        for q in query
    ]

    return jsonify(schema),200


#Obtener los usuarios anfitrion que pertenecen a cierta ubicacion
@bp.route('/getUsuariosxUbicacion/<int:idUbicacion>', methods=['GET'])
@cross_origin()
@jwt_required()
def getUsuariosxUbicacion(idUbicacion):
    codigoUsuario = get_jwt_identity()

    query = (
        db.session.query(Persona)
        .join(SAMM_Usuario, SAMM_Usuario.IdPersona == Persona.Id)
        .join(SAMM_UbiUsuario, SAMM_Usuario.Id == SAMM_UbiUsuario.IdUsuario)
        .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
        .filter(SAMM_Usuario.Codigo != codigoUsuario, SAMM_UbiUsuario.EsAnfitrion == True, SAMM_Ubicacion.Id == idUbicacion, SAMM_Usuario.Estado == "A")
        .all()
    )

    schema= [
        {
            'Id': q.Id,
            'Identificacion': q.Identificacion,
            'Nombres' : q.Nombres,
            'Apellidos' : q.Apellidos
        }
        for q in query
    ]

    return jsonify(schema),200


#Obtener todas las bitacora visitas de un usuario anfitrion
@bp.route('/getAllBitacoraVisitas', methods=['GET'])
@cross_origin()
@jwt_required()
def getAllBitacoraVisitas():
    codigoUsuario = get_jwt_identity()

    query = (
        db.session.query(SAMM_BitacoraVisita,Persona,SAMM_Ubicacion)
        .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraVisita.IdAnfitrion)
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
        .join(SAMM_UbiUsuario, SAMM_UbiUsuario.IdUbicacion == SAMM_BitacoraVisita.IdUbicacion)
        .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
        .filter(SAMM_BitacoraVisita.Estado == 'A', SAMM_UbiUsuario.EsAnfitrion==True, SAMM_Usuario.Codigo == codigoUsuario)
        .all()
    )

    schema= [
        {
            'Id': q.SAMM_BitacoraVisita.Id,
            "Estado":q.SAMM_BitacoraVisita.Estado,
            "IdAnfitrion":q.SAMM_BitacoraVisita.IdAnfitrion, #idUsuario
            "IdentificacionAnfitrion": q.Persona.Identificacion,
            "NombresAnfitrion":q.Persona.Nombres,
            "ApellidosAnfitrion":q.Persona.Apellidos,
            "IdVisitante":q.SAMM_BitacoraVisita.IdVisita,
            "IdentificacionVisitante": q.SAMM_BitacoraVisita.IdentificacionVisitante,
            "NombresVisitante":q.SAMM_BitacoraVisita.NombresVisitante,
            "ApellidosVisitante":q.SAMM_BitacoraVisita.ApellidosVisitante,
            "AntecdentesPenales": q.SAMM_BitacoraVisita.Antecedentes,
            "Ubicacion":q.SAMM_Ubicacion.Descripcion,
            "Celular":q.SAMM_BitacoraVisita.Telefono,
            "Correo":q.SAMM_BitacoraVisita.Correo,
            "Placa":q.SAMM_BitacoraVisita.Placa,
            "Observaciones": q.SAMM_BitacoraVisita.Observaciones,
            "FechaTimeVisitaEstimada":q.SAMM_BitacoraVisita.FechaTimeVisitaEstimada,
            "FechaTimeVisitaReal":q.SAMM_BitacoraVisita.FechaTimeVisitaReal,
            "FechaTimeSalidaEstimada":q.SAMM_BitacoraVisita.FechaTimeSalidaEstimada,
            "FechaTimeSalidaReal":q.SAMM_BitacoraVisita.FechaTimeSalidaReal,
            
        }
        for q in query
    ]


    return jsonify({'data':schema}),200









