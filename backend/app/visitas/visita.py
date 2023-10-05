from flask import jsonify, request
from flask_cors import cross_origin
from app.visitas import bp
from app.extensions import db
from sqlalchemy import func, text
import base64
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime, timedelta
import time
from sqlalchemy import or_

from app.models.SAMM_UbiUsuario import SAMM_UbiUsuario,SAMM_UbiUsuarioSchema
from app.models.SAMM_Ubicacion import SAMM_Ubicacion,SAMM_UbicacionSchema
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema
from app.models.SAMM_Persona import Persona
from app.models.SAMM_BitacoraVisita import SAMM_BitacoraVisita, SAMM_BitacoraVisitaSchema
from app.models.SAMM_Estaddos import SAMM_Estados

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
        db.session.query(Persona,SAMM_Usuario)
        .join(SAMM_Usuario, SAMM_Usuario.IdPersona == Persona.Id)
        .join(SAMM_UbiUsuario, SAMM_Usuario.Id == SAMM_UbiUsuario.IdUsuario)
        .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
        .filter(SAMM_Usuario.Codigo != codigoUsuario, SAMM_UbiUsuario.EsAnfitrion == True, SAMM_Ubicacion.Id == idUbicacion, SAMM_Usuario.Estado == "A")
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


#Obtener todas las bitacora visitas de un usuario anfitrion
@bp.route('/getAllBitacoraVisitas', methods=['GET'])
@cross_origin()
@jwt_required()
def getAllBitacoraVisitas():
    codigoUsuario = get_jwt_identity()
    #TODO:Rol deberia obtnerse del token y no hacerse esta consulta
    usuario = (
        db.session.query(SAMM_Usuario.IdPerfil, SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo == codigoUsuario).first()
    )

    rol = usuario[0]
    idUsuario = usuario[1]
    print(idUsuario)


    print(rol)
    #En el caso de que se anfitrion osea id 3
    if(rol == 3):
        query = (
            db.session.query(SAMM_BitacoraVisita,Persona,SAMM_Ubicacion,SAMM_Estados)
            .join(SAMM_Estados, SAMM_BitacoraVisita.Estado == SAMM_Estados.Id)
            .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraVisita.IdAnfitrion)
            .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
            .join(SAMM_UbiUsuario, SAMM_UbiUsuario.IdUbicacion == SAMM_BitacoraVisita.IdUbicacion)
            .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
            .filter(SAMM_BitacoraVisita.IdAnfitrion == idUsuario )
            .all()
        )
        schema= [
            {
                'Id': q.SAMM_BitacoraVisita.Id,
                "CodigoEstado":q.SAMM_Estados.Id,
                "Estado":q.SAMM_Estados.Descripcion,
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

    

    #Esto traere todas las bitacoras si no es anfitrion

    query = (
        db.session.query(SAMM_BitacoraVisita,Persona,SAMM_Ubicacion,SAMM_Estados)
        .join(SAMM_Estados, SAMM_BitacoraVisita.Estado == SAMM_Estados.Id)
        .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraVisita.IdAnfitrion)
        .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
        .join(SAMM_UbiUsuario, SAMM_UbiUsuario.IdUbicacion == SAMM_BitacoraVisita.IdUbicacion)
        .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
        .all()
    )

    schema= [
        {
            'Id': q.SAMM_BitacoraVisita.Id,
            "CodigoEstado":q.SAMM_Estados.Id,
            "Estado":q.SAMM_Estados.Descripcion,
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


# @bp.route('/getAllBitacoraVisitasCondense', methods=['GET'])
# @cross_origin()
# @jwt_required()
# def getAllBitacoraVisitasCondense():
#     codigoUsuario = get_jwt_identity()
#     #TODO:Rol deberia obtnerse del token y no hacerse esta consulta
#     usuario = (
#         db.session.query(SAMM_Usuario.IdPerfil, SAMM_Usuario.Id).filter(SAMM_Usuario.Codigo == codigoUsuario).first()
#     )

#     rol = usuario[0]
#     idUsuario = usuario[1]
#     print(idUsuario)


#     print(rol)
#     #En el caso de que se anfitrion osea id 3
#     if(rol == 3):
#         query = (
#             db.session.query(
#                 SAMM_BitacoraVisita,Persona,SAMM_Ubicacion,SAMM_Estados)
#             .join(SAMM_Estados, SAMM_BitacoraVisita.Estado == SAMM_Estados.Id)
#             .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraVisita.IdAnfitrion)
#             .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
#             .join(SAMM_UbiUsuario, SAMM_UbiUsuario.IdUbicacion == SAMM_BitacoraVisita.IdUbicacion)
#             .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
#             .filter(SAMM_BitacoraVisita.IdAnfitrion == idUsuario)
#             .group_by(SAMM_BitacoraVisita.IdentificacionVisitante)
#             .all()
#         )
#         schema= [
#             {
#                 'Id': q.SAMM_BitacoraVisita.Id,
#                 "CodigoEstado":q.SAMM_Estados.Id,
#                 "Estado":q.SAMM_Estados.Descripcion,
#                 "IdAnfitrion":q.SAMM_BitacoraVisita.IdAnfitrion, #idUsuario
#                 "IdentificacionAnfitrion": q.Persona.Identificacion,
#                 "NombresAnfitrion":q.Persona.Nombres,
#                 "ApellidosAnfitrion":q.Persona.Apellidos,
#                 "IdVisitante":q.SAMM_BitacoraVisita.IdVisita,
#                 "IdentificacionVisitante": q.SAMM_BitacoraVisita.IdentificacionVisitante,
#                 "NombresVisitante":q.SAMM_BitacoraVisita.NombresVisitante,
#                 "ApellidosVisitante":q.SAMM_BitacoraVisita.ApellidosVisitante,
#                 "AntecdentesPenales": q.SAMM_BitacoraVisita.Antecedentes,
#                 "Ubicacion":q.SAMM_Ubicacion.Descripcion,
#                 "Celular":q.SAMM_BitacoraVisita.Telefono,
#                 "Correo":q.SAMM_BitacoraVisita.Correo,
#                 "Placa":q.SAMM_BitacoraVisita.Placa,
#                 "Observaciones": q.SAMM_BitacoraVisita.Observaciones,
#                 "FechaTimeVisitaEstimada":q.SAMM_BitacoraVisita.FechaTimeVisitaEstimada,
#                 "FechaTimeVisitaReal":q.SAMM_BitacoraVisita.FechaTimeVisitaReal,
#                 "FechaTimeSalidaEstimada":q.SAMM_BitacoraVisita.FechaTimeSalidaEstimada,
#                 "FechaTimeSalidaReal":q.SAMM_BitacoraVisita.FechaTimeSalidaReal,
                
#             }
#             for q in query
#         ]
#         return jsonify({'data':schema}),200

    

#     #Esto traere todas las bitacoras si no es anfitrion

#     query = (
#         db.session.query(SAMM_BitacoraVisita,Persona,SAMM_Ubicacion,SAMM_Estados)
#         .join(SAMM_Estados, SAMM_BitacoraVisita.Estado == SAMM_Estados.Id)
#         .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraVisita.IdAnfitrion)
#         .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
#         .join(SAMM_UbiUsuario, SAMM_UbiUsuario.IdUbicacion == SAMM_BitacoraVisita.IdUbicacion)
#         .join(SAMM_Ubicacion, SAMM_UbiUsuario.IdUbicacion == SAMM_Ubicacion.Id)
#         .group_by(SAMM_BitacoraVisita.IdentificacionVisitante)
#         .all()
#     )

#     schema= [
#         {
#             'Id': q.SAMM_BitacoraVisita.Id,
#             "CodigoEstado":q.SAMM_Estados.Id,
#             "Estado":q.SAMM_Estados.Descripcion,
#             "IdAnfitrion":q.SAMM_BitacoraVisita.IdAnfitrion, #idUsuario
#             "IdentificacionAnfitrion": q.Persona.Identificacion,
#             "NombresAnfitrion":q.Persona.Nombres,
#             "ApellidosAnfitrion":q.Persona.Apellidos,
#             "IdVisitante":q.SAMM_BitacoraVisita.IdVisita,
#             "IdentificacionVisitante": q.SAMM_BitacoraVisita.IdentificacionVisitante,
#             "NombresVisitante":q.SAMM_BitacoraVisita.NombresVisitante,
#             "ApellidosVisitante":q.SAMM_BitacoraVisita.ApellidosVisitante,
#             "AntecdentesPenales": q.SAMM_BitacoraVisita.Antecedentes,
#             "Ubicacion":q.SAMM_Ubicacion.Descripcion,
#             "Celular":q.SAMM_BitacoraVisita.Telefono,
#             "Correo":q.SAMM_BitacoraVisita.Correo,
#             "Placa":q.SAMM_BitacoraVisita.Placa,
#             "Observaciones": q.SAMM_BitacoraVisita.Observaciones,
#             "FechaTimeVisitaEstimada":q.SAMM_BitacoraVisita.FechaTimeVisitaEstimada,
#             "FechaTimeVisitaReal":q.SAMM_BitacoraVisita.FechaTimeVisitaReal,
#             "FechaTimeSalidaEstimada":q.SAMM_BitacoraVisita.FechaTimeSalidaEstimada,
#             "FechaTimeSalidaReal":q.SAMM_BitacoraVisita.FechaTimeSalidaReal,
            
#         }
#         for q in query
#     ]


#     return jsonify({'data':schema}),200






@bp.route('/registraVisita', methods=['POST'])
@cross_origin()
@jwt_required()
def registraVisita():
    
    currentUserID =  get_jwt_identity() #CODIGO usuario

    visita = SAMM_BitacoraVisita()

    # Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    # Descripcion = db.Column(db.String(200))
    
    # UsuarioCrea = db.Column(db.String(255))*********
    # UsuarioModifica = db.Column(db.String(255))*********
    # FechaCrea = db.Column(db.DateTime)***********
    # FechaModifica = db.Column(db.DateTime)***********

    #Descripcion = db.Column(db.String(200))********!!!!!!!!

    # Estado = db.Column(db.String(1))*****!!!
    
    # Duracion = db.Column(db.Integer)*********!!!!

    # FechaTimeVisitaEstimada = db.Column(db.DateTime)******
    # FechaTimeVisitaReal = db.Column(db.DateTime)
    # FechaTimeSalidaEstimada = db.Column(db.DateTime)************
    # FechaTimeSalidaReal = db.Column(db.DateTime)
   
   
    # Alertas = db.Column(db.String(255))

    print(request.json['nameVisitante'])
    visita.NombresVisitante= request.json['nameVisitante']
    visita.ApellidosVisitante = request.json['lastNameVisitante']
    visita.IdentificacionVisitante = str(request.json['cedula'])
    # visita.Descripcion = 'Visita de ' + request.json['name'] + ' ' + request.json['lastName'] + ' a ' + anfitrion.Nombres + ' ' + anfitrion.Apellidos
    visita.IdAnfitrion = request.json['idAnfitrion']
    visita.IdVisita=  request.json['idVisitante']
    visita.IdUbicacion = request.json["idUbicacion"]
    visita.Antecedentes = request.json["antecedentes"]
    visita.Telefono = request.json["phone"]
    visita.Correo = request.json["email"]
    visita.Placa= request.json['placa']
    visita.Observaciones = request.json['observaciones']


    visita.Estado = 2

    visita.FechaCrea = datetime.now()
    visita.FechaModifica = datetime.now()


    visita.UsuarioCrea = currentUserID
    visita.UsuarioModifica = currentUserID

    #transformar fecha de string a date
    #join time and date
    date_time_str = request.json['date'] + ' ' + request.json['time']
    date_time_obj = datetime.strptime(date_time_str, '%Y-%m-%d %H:%M')
    visita.FechaTimeVisitaEstimada = date_time_obj

    visita.Duracion= request.json['duration']

    # para hora estimada de salida sumarle la duracion a la hora de entrada
    #transformar duracion de horas a minutos
    Duracion= request.json['duration']*60
    FechaSalidaEstimada = date_time_obj + timedelta(minutes=int(Duracion))
    visita.FechaTimeSalidaEstimada = FechaSalidaEstimada
    db.session.add(visita)
    db.session.commit()

    
    # temp_user_dict={
    #     'Id':usuario.Id,
    #     'IdPersona':usuario.IdPersona,
    #     'Nombres':visitante.Nombres,
    #     'Apellidos':visitante.Apellidos,
    #     'Codigo':usuario.Codigo,
    #     'Clave':usuario.Codigo,
    #     'IdPerfil':usuario.IdPerfil,
    #     'Estado':usuario.Estado,
    #     'FechaCrea':usuario.FechaCrea,
    #     'access_token': create_access_token(identity=usuario.Codigo),
    #     'UsuarioCrea':usuario.UsuarioCrea,
    #     'UsuarioModifica':usuario.UsuarioModifica,
    #     'Confirmado':usuario.Confirmado,
    #     'FechaConfirmacion':usuario.FechaConfirmacion,
    #     "visita": {
    #         'Id':visita.Id,
    #         'Codigo':visita.Codigo,
    #         'Descripcion':visita.Descripcion,
    #         'IdAnfitrion':visita.IdAnfitrion,
    #         'IdVisita':visita.IdVisita,
    #         'IdUbicacion':visita.IdUbicacion,
    #         'FechaVisita':visita.FechaVisita,
    #         'FechaSalidaEstimada':visita.FechaSalidaEstimada,

    #     }
    # }
    # return the new user and their JWT to the client
    # return jsonify(visita=temp_user_dict), 201
    return jsonify({"msg":"Visita creada"}), 201





#obtener info de la persona usuando su identificaion
@bp.route('/buscarPersonaXIden/<cedula>', methods=['GET'])	
@cross_origin()
@jwt_required()
def existePersona(cedula):
    try:
        persona = (
            db.session.query(Persona,SAMM_Usuario)
            .join(SAMM_Usuario, Persona.Id == SAMM_Usuario.IdPersona)
            .filter(Persona.Identificacion==cedula)
            .first()
            )
        
        if persona is None:
            return jsonify({'message': 'Persona no existe'}), 400
        
        schema = {
            "Nombres": persona.Persona.Nombres,
            "Apellidos": persona.Persona.Apellidos,
            "idUsuario": persona.SAMM_Usuario.Id 
        }
        return jsonify(schema), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    


@bp.route('/marcarLlegadaReal/<int:idBitacoraVisita>', methods=['PUT'])	
@cross_origin()
@jwt_required()
def marcarLlegadaReal(idBitacoraVisita):
    print(idBitacoraVisita)
    codigoUsuario =  get_jwt_identity()

    query = db.session.query(SAMM_BitacoraVisita).filter(SAMM_BitacoraVisita.Id == idBitacoraVisita).first()

    print(query)
    query.FechaTimeVisitaReal = datetime.now()
    query.Estado = 3
    query.UsuarioModifica = codigoUsuario
    query.FechaModifica = datetime.now()

    db.session.add(query)
    db.session.commit()

    return jsonify({"msg":"Resgistro exitoso"}), 200


@bp.route('/marcarSalidaReal/<int:idBitacoraVisita>', methods=['PUT'])	
@cross_origin()
@jwt_required()
def marcarSalidaReal(idBitacoraVisita):
    print(idBitacoraVisita)
    codigoUsuario =  get_jwt_identity()

    query = db.session.query(SAMM_BitacoraVisita).filter(SAMM_BitacoraVisita.Id == idBitacoraVisita).first()

    print(query)
    query.FechaTimeSalidaReal = datetime.now()
    query.Estado = 4
    query.UsuarioModifica = codigoUsuario
    query.FechaModifica = datetime.now()

    db.session.add(query)
    db.session.commit()

    return jsonify({"msg":"Resgistro exitoso"}), 200










