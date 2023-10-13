from flask import jsonify, request
from flask_cors import cross_origin
from app.rondas import bp
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
from app.models.SAMM_Ronda_Detalle import SAMM_Ronda_Detalle
from app.models.SAMM_Ronda_Usuario import SAMM_Ronda_Usuario

#pensado para admin y supervisor

@bp.route('/getAllRondas', methods=['GET'])
@cross_origin()
@jwt_required()
def getAllRondas():
    
    query = (
        db.session.query(SAMM_Ronda, Persona, SAMM_Ubicacion,SAMM_Estados,SAMM_Usuario)
        .join(SAMM_Usuario, SAMM_Ronda.IdUsuarioSupervisor == SAMM_Usuario.Id, isouter=True)
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id, isouter=True)
        .join(SAMM_Ubicacion, SAMM_Ronda.IdUbicacion == SAMM_Ubicacion.Id, isouter=True)
        .join(SAMM_Estados, SAMM_Ronda.Estado == SAMM_Estados.Id)
        .all()
        )
    
    schema = [
    {
        "Id": q.SAMM_Ronda.Id,
        "IdUsuarioSupervisor": q.SAMM_Ronda.IdUsuarioSupervisor,
        "NombreSupervisor": f"{q.Persona.Nombres} {q.Persona.Apellidos}" if q.Persona else None,
        "Estado": q.SAMM_Estados.Descripcion,
        "IdUbicacion": q.SAMM_Ronda.IdUbicacion,
        "NameUbicacion": q.SAMM_Ubicacion.Descripcion if q.SAMM_Ubicacion else None,
        "FechaCreacion": q.SAMM_Ronda.FechaCreacion,
        "FechaModifica": q.SAMM_Ronda.FechaModifica,
        "descripcion": q.SAMM_Ronda.Desripcion,
        "Ubicacion":{
            'id': q.SAMM_Ubicacion.Id,
            'codigo': q.SAMM_Ubicacion.Codigo,
            'tipo': q.SAMM_Ubicacion.Tipo,
            'descripcion': q.SAMM_Ubicacion.Descripcion,
            'fecha_crea': q.SAMM_Ubicacion.FechaCrea.strftime('%d-%m-%Y'),
            'hora_crea': q.SAMM_Ubicacion.FechaCrea.strftime('%H:%M:%S'),
            'codigo_usuario_crea': q.SAMM_Ubicacion.UsuarioCrea,
            'fecha_modifica': q.SAMM_Ubicacion.FechaModifica.strftime('%d-%m-%Y'),
            'hora_modifica': q.SAMM_Ubicacion.FechaModifica.strftime('%H:%M:%S'),
            'codigo_usuario_modifica': q.SAMM_Ubicacion.UsuarioModifica,
            'estado': q.SAMM_Ubicacion.Estado
        },
        # "Supervisor":{
        #     'Id': q.Persona.Id,
        #     "IdUsuario": q.SAMM_Usuario.Id,
        #     'Identificacion': q.Persona.Identificacion,
        #     'Nombres' : q.Persona.Nombres,
        #     'Apellidos' : q.Persona.Apellidos
            
        # }
    }
    for q in query
]


    return jsonify({"data":schema}), 200


#Trae todas las ubicaciones(es la misma que esta en visitas)
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
    

#Obtener los supervisores anfitriones que pertenecen a cierta ubicacion
@bp.route('/getSupervisoresxUbicacion/<int:idUbicacion>', methods=['GET'])
@cross_origin()
@jwt_required()
def getSupervisoresxUbicacion(idUbicacion):

    query = (
        db.session.query(Persona,SAMM_Usuario)
        .join(SAMM_Usuario, SAMM_Usuario.IdPersona == Persona.Id)
        .join(SAMM_UbiUsuario, SAMM_Usuario.Id == SAMM_UbiUsuario.IdUsuario)
        .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
        .filter(SAMM_UbiUsuario.EsAnfitrion == True, SAMM_Ubicacion.Id == idUbicacion, SAMM_Usuario.Estado == "A", SAMM_Usuario.IdPerfil == 4)
        .all()
    )

    schema= [
        {
            'Id': q.Persona.Id,
            "IdUsuario": q.SAMM_Usuario.Id,
            'Identificacion': q.Persona.Identificacion,
            'Nombres' : q.Persona.Nombres,
            'Apellidos' : q.Persona.Apellidos
        }
        for q in query
    ]

    return jsonify(schema),200


@bp.route('/crearRonda', methods=['POST'])
@cross_origin()
@jwt_required()
def crearRonda():
    
    currentUserID =  get_jwt_identity() #CODIGO usuario
    idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo== currentUserID).first()

    ronda = SAMM_Ronda()

    ronda.Desripcion = request.json['Desripcion']
    ronda.Estado = 0
    ronda.IdUbicacion = request.json['IdUbicacion']
    ronda.FechaCreacion = datetime.now()
    ronda.UsuCreacion = idUsuario[0]
    ronda.FechaModifica = datetime.now()
    ronda.UsuModifica = idUsuario[0]
    ronda.IdUsuarioSupervisor = request.json['IdUsuarioSupervisor']

   
   
   
    db.session.add(ronda)
    db.session.commit()

    return jsonify({
        "msg":"Ronda creada",
        "IdRonda": ronda.Id
        }), 201

@bp.route('/editarRonda', methods=['POST'])
@cross_origin()
@jwt_required()
def editarRonda():
    
    currentUserID =  get_jwt_identity() #CODIGO usuario
    idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo== currentUserID).first()

    IdRonda = request.json["IdRonda"]

    ronda = db.session.query(SAMM_Ronda).filter(SAMM_Ronda.Id == IdRonda).first()

    ronda.Desripcion = request.json['Desripcion']
    ronda.Estado = 0
    ronda.IdUbicacion = request.json['IdUbicacion']
    ronda.FechaModifica = datetime.now()
    ronda.UsuModifica = idUsuario[0]
    ronda.IdUsuarioSupervisor = request.json['IdUsuarioSupervisor']

   
   
   
    db.session.add(ronda)
    db.session.commit()

    return jsonify({"msg":"Ronda actualizada"}), 201


@bp.route('/guardarPuntoRealizado', methods=['POST'])
@cross_origin()
@jwt_required()
def guardarPuntoRealizado():
    
    currentUserID =  get_jwt_identity() #CODIGO usuario
    idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo== currentUserID).first()

    IdRonda = request.json["IdRonda"]

    rondaDetalle = SAMM_Ronda_Detalle()

    rondaDetalle.IdUsuario = idUsuario[0]
    rondaDetalle.IdRonda = IdRonda
    rondaDetalle.Estado = 0
    rondaDetalle.IdPuntoRonda = request.json['IdPuntoRonda']
    rondaDetalle.Codigo = request.json['Codigo']
    rondaDetalle.Descripcion = request.json['Descripcion']
    rondaDetalle.FotoURL = request.json['FotoURL']

   
    db.session.add(rondaDetalle)
    db.session.commit()

    return jsonify({
        "msg":"punto registrado",
        "IdRonda": rondaDetalle.Id
        }), 201


@bp.route('/guardarRondaRealizadaXUsuario', methods=['POST'])
@cross_origin()
@jwt_required()
def guardarRondaRealizadaXUsuario():
    
    currentUserID =  get_jwt_identity() #CODIGO usuario
    idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo== currentUserID).first()

    IdRonda = request.json["IdRonda"]

    rondaUsuario = SAMM_Ronda_Usuario()

    rondaUsuario.IdUsuario = idUsuario[0]
    rondaUsuario.IdRonda = IdRonda
    rondaUsuario.Estado = 0
    rondaUsuario.FechaCrea = datetime.now()
    rondaUsuario.UsuCrea = idUsuario[0]
    rondaUsuario.FechaMod = datetime.now()
    rondaUsuario.UsuMod = idUsuario[0]

   
    db.session.add(rondaUsuario)
    db.session.commit()

    return jsonify({
        "msg":"Ronda creada",
        "IdRonda": rondaUsuario.Id
        }), 201



# @bp.route('/getMisRondas', methods=['GET'])
# @cross_origin()
# @jwt_required()
# def getMisRondas():
    
#     query = (
#         db.session.query(SAMM_Ronda, Persona, SAMM_Ubicacion,SAMM_Estados,SAMM_Usuario)
#         .join(SAMM_Usuario, SAMM_Ronda.IdUsuarioSupervisor == SAMM_Usuario.Id, isouter=True)
#         .join(Persona, SAMM_Usuario.IdPersona == Persona.Id, isouter=True)
#         .join(SAMM_Ubicacion, SAMM_Ronda.IdUbicacion == SAMM_Ubicacion.Id, isouter=True)
#         .join(SAMM_Estados, SAMM_Ronda.Estado == SAMM_Estados.Id)
#         .all()
#         )
    
#     schema = [
#         {
#             "Id": q.SAMM_Ronda.Id,
#             "IdUsuarioSupervisor": q.SAMM_Ronda.IdUsuarioSupervisor,
#             "NombreSupervisor": f"{q.Persona.Nombres} {q.Persona.Apellidos}" if q.Persona else None,
#             "Estado": q.SAMM_Estados.Descripcion,
#             "IdUbicacion": q.SAMM_Ronda.IdUbicacion,
#             "NameUbicacion": q.SAMM_Ubicacion.Descripcion if q.SAMM_Ubicacion else None,
#             "FechaCreacion": q.SAMM_Ronda.FechaCreacion,
#             "FechaModifica": q.SAMM_Ronda.FechaModifica,
#             "Ubicacion":{
#                 'id': q.SAMM_Ubicacion.Id,
#                 'codigo': q.SAMM_Ubicacion.Codigo,
#                 'tipo': q.SAMM_Ubicacion.Tipo,
#                 'descripcion': q.SAMM_Ubicacion.Descripcion,
#                 'fecha_crea': q.SAMM_Ubicacion.FechaCrea.strftime('%d-%m-%Y'),
#                 'hora_crea': q.SAMM_Ubicacion.FechaCrea.strftime('%H:%M:%S'),
#                 'codigo_usuario_crea': q.SAMM_Ubicacion.UsuarioCrea,
#                 'fecha_modifica': q.SAMM_Ubicacion.FechaModifica.strftime('%d-%m-%Y'),
#                 'hora_modifica': q.SAMM_Ubicacion.FechaModifica.strftime('%H:%M:%S'),
#                 'codigo_usuario_modifica': q.SAMM_Ubicacion.UsuarioModifica,
#                 'estado': q.SAMM_Ubicacion.Estado
#             },
#             "Supervisor":{
#                 'Id': q.Persona.Id,
#                 "IdUsuario": q.SAMM_Usuario.Id,
#                 'Identificacion': q.Persona.Identificacion,
#                 'Nombres' : q.Persona.Nombres,
#                 'Apellidos' : q.Persona.Apellidos
                
#             }
#         }
#         for q in query
#     ]


#     return jsonify({"data":schema}), 200