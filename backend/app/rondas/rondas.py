from flask import jsonify, request
from flask_cors import cross_origin
from app.rondas import bp
from app.extensions import db
from sqlalchemy import and_, text
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

from app.models.SAMM_Ronda import SAMM_Ronda,SAMM_RondaSchema
from app.models.SAMM_Ronda_Punto import SAMM_Ronda_Punto,SAMM_Ronda_PuntoSchema
from app.models.SAMM_Ronda_Detalle import SAMM_Ronda_Detalle
from app.models.SAMM_Ronda_Usuario import SAMM_Ronda_Usuario
from app.models.SAMM_RolUsu import SAMM_RolUsu

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
        .order_by(SAMM_Ronda.FechaCreacion.desc())  # Ordenar por fecha descendente
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


    return jsonify({"total":len(schema),"data":schema}), 200




    
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
    ronda.FechaInicio = request.json['FechaInicio']
    ronda.FechaFin = request.json['FechaFin']
    ronda.Frecuencia = request.json['Frecuencia'] 
    ronda.diaSemana = request.json['DiaSemana'] or None
    ronda.NumDiaMes = request.json['NumDiaMes'] or None

   
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
    try:
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
    except Exception as e:
        return jsonify({'message': str(e)}), 500



@bp.route('/getPuntosPorRonda', methods=['POST'])
@cross_origin()
@jwt_required()
def getPuntoPorRonda():
    try:
        idRonda = request.json["IdRonda"]
        
        ronda_existe = SAMM_Ronda.query.filter(SAMM_Ronda.Id == idRonda).first()
        
        if (ronda_existe is None):
            return jsonify({"message":"Ronda no existe"}),400
        puntos = SAMM_Ronda_Punto.query.filter(SAMM_Ronda_Punto.IdRonda==idRonda).all()
        puntos_schema=SAMM_Ronda_PuntoSchema(many=True)
        
        return jsonify({"data":puntos_schema.dump(puntos),"total":len(puntos)})
    except Exception as e:
        return jsonify({'message': str(e)}), 500


@bp.route('/guardarPuntoRealizado', methods=['POST'])
@cross_origin()
@jwt_required()
def guardarPuntoRealizado():
    try:
        currentUserID =  get_jwt_identity() #CODIGO usuario
        idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo== currentUserID).first()

        IdRonda = request.json["IdRonda"]

        rondaDetalle = SAMM_Ronda_Detalle()

        rondaDetalle.IdUsuario = idUsuario[0]
        rondaDetalle.IdRonda = IdRonda
        rondaDetalle.Estado = 1
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
    except Exception as e:
        return jsonify({'message': str(e)}), 500



@bp.route('/guardarRondaAsignadaXUsuario', methods=['POST'])
@cross_origin()
@jwt_required()
def guardarRondaAsignadaXUsuario():
    currentUserID = get_jwt_identity()  # CODIGO usuario

    rondaUsuario = SAMM_Ronda_Usuario()

    # rondaUsuario.IdRonda = 1
    rondaUsuario.IdRonda = request.json["idronda"]
    # rondaUsuario.IdUsuario = 1
    rondaUsuario.IdUsuario = request.json["idguardia"]
    rondaUsuario.Estado = "A"
    rondaUsuario.FechaCrea = datetime.now()
    # rondaUsuario.UsuCrea = 1
    rondaUsuario.FechaMod = datetime.now()
    # rondaUsuario.UsuMod = 1

    idUsuario = db.session.query(SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo == currentUserID).first()
    # if idUsuario:
    rondaUsuario.UsuCrea = idUsuario[0]
    rondaUsuario.UsuMod = idUsuario[0]
    # else:
    #     rondaUsuario.UsuCrea = 1
    #     rondaUsuario.UsuMod = 1


    print(rondaUsuario.IdUsuario)
    print(rondaUsuario.IdRonda)
    print(rondaUsuario.Estado)
    print(rondaUsuario.FechaCrea)
    print(rondaUsuario.UsuCrea)
    print(rondaUsuario.FechaMod)
    print(rondaUsuario.UsuMod)

    db.session.add(rondaUsuario)
    db.session.commit()

    return jsonify({
        "msg": "Ronda asignada al usuario",
        "IdRonda": rondaUsuario.Id
    }), 201



# @bp.route('/getUsuariosPorRonda/<int:IdRonda>', methods=['GET'])
# @cross_origin()
# @jwt_required()
# def getUsuariosPorRonda(IdRonda):
#     # Obtén la lista de usuarios asignados a la ronda con el IdRonda especificado
#     usuarios_en_ronda = db.session.query(
#         SAMM_Ronda_Usuario
#     ).filter(
#         SAMM_Ronda_Usuario.IdRonda == IdRonda
#     ).all()

#     # Ahora, obtén la información de los usuarios correspondientes a los IdUsuario obtenidos
#     usuarios_info = []
#     for ronda_usuario in usuarios_en_ronda:
#         ronda_usuario_schema = SAMM_Ronda_UsuarioSchema()
#         ronda_usuario_data = ronda_usuario_schema.dump(ronda_usuario)
#         usuarios_info.append(ronda_usuario_data)

#     return jsonify({
#         "data": usuarios_info
#     }), 200


@bp.route('/getUsuariosPorRonda/<int:id_ronda>', methods=['GET'])
@cross_origin()
@jwt_required()
def getUsuariosPorRonda(id_ronda):
    # # Obtén la lista de usuarios asignados a la ronda con el IdRonda especificado
    # usuarios_en_ronda = db.session.query(
    #     SAMM_Ronda_Usuario.IdUsuario

    # ).filter(
    #     SAMM_Ronda_Usuario.IdRonda == IdRonda
    # ).all()

    # # Ahora, obtén la información de los usuarios correspondientes a los IdUsuario obtenidos
    # usuarios_info = []
    # for usuario_id in usuarios_en_ronda:
    #     usuario = db.session.query(
    #         SAMM_Usuario,
    #     ).filter(
    #         SAMM_Usuario.Id == usuario_id[0]
    #     ).first()
    #     if usuario:
    #         usuario_schema = SAMM_UsuarioSchema()
    #         usuario_data = usuario_schema.dump(usuario)
    #         # Elimina el campo "Clave" del diccionario antes de agregarlo a la lista
    #         if 'Clave' in usuario_data:
    #             del usuario_data['Clave']
    #         usuarios_info.append(usuario_data)

    # return jsonify({
    #     "data": usuarios_info
    # }), 200
    try:
        # Buscar los IDs de usuarios en la ronda especificada
        ronda_usuarios = SAMM_Ronda_Usuario.query.filter_by(IdRonda=id_ronda).all()
        
        # Crear una lista de diccionarios con los nombres e IDs de las personas
        data = []
        for ronda_usuario in ronda_usuarios:
            usuario = SAMM_Usuario.query.get(ronda_usuario.IdUsuario)
            if usuario:
                persona = Persona.query.get(usuario.IdPersona)
                if persona:
                    data.append({
                        'Nombres': persona.Nombres,
                        'Apellidos': persona.Apellidos,
                        'Id': usuario.Id,
                    })

        return jsonify({'data': data})
    except Exception as e:
        return jsonify({'error': 'Ocurrió un error al obtener los nombres e IDs de las personas en la ronda.'}), 500




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