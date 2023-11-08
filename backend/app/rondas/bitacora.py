from datetime import datetime, timedelta
from app.rondas import bp
from flask_cors import cross_origin
from app.models.SAMM_Persona import Persona
from flask import jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.extensions import db

from app.models.SAMM_BitacoraRecorrido import SAMM_BitacoraRecorrido,SAMM_BitacoraRecorridoSchema
from app.models.SAMM_Bitacora_RecorridoDetalle import SAMM_Bitacora_RecorridoDetalle,SAMM_Bitacora_RecorridoDetalleSchema
from app.models.SAMM_Usuario import SAMM_Usuario
from app.models.SAMM_Ronda import SAMM_Ronda
from app.models.SAMM_Ronda_Punto import SAMM_Ronda_Punto,SAMM_Ronda_PuntoSchema
from app.models.SAMM_Ubicacion import SAMM_Ubicacion



@bp.route('/getPuntosRecorridoxRonda', methods=['POST'])
@cross_origin()
@jwt_required()
def getPuntosRecorridoxRonda():
    try:
        # '''idRonda = request.json["idRonda"]
        # idAgente = request.json["idAgente"]
        # agente_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.IdAgente == idAgente).first()
        # ronda_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.IdRonda == idRonda).first()

        # if (agente_existe is None):
        #     return jsonify({"message":"Usuario Agente no existe en bitacora"}),400
        # if (ronda_existe is None):
        #     return jsonify({"message":"Ronda no existe en bitacora"}),400
        # '''
        idRecorrido=request.json["idRecorrido"]
        recorrido_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.Id == idRecorrido).first()
        if (recorrido_existe is None):
            return jsonify({"message":"Recorrido no existe en bitacora"}),400
        
        
        
        query = (
            db.session.query(SAMM_Bitacora_RecorridoDetalle,SAMM_Ronda,SAMM_Ronda_Punto,SAMM_Usuario,Persona)
            .join(SAMM_Ronda, SAMM_Ronda.Id ==SAMM_Bitacora_RecorridoDetalle.IdRonda)
            .join(SAMM_Ronda_Punto, SAMM_Ronda_Punto.Id ==SAMM_Bitacora_RecorridoDetalle.IdPuntoRonda)                        
            .join(SAMM_Usuario,SAMM_Usuario.Id == SAMM_Bitacora_RecorridoDetalle.IdUsuario)
            .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
            .filter(
                SAMM_Bitacora_RecorridoDetalle.IdBitacoraRecorrido == idRecorrido,
                
            )
            .all()
        )

        schema= [
            {   'idRecorrido':q.SAMM_Bitacora_RecorridoDetalle.IdBitacoraRecorrido,
                'IdRonda': q.SAMM_Bitacora_RecorridoDetalle.IdRonda,
                "IdAgente": q.SAMM_Bitacora_RecorridoDetalle.IdUsuario,
                'IdUsuarioSupervisor':q.SAMM_Ronda.IdUsuarioSupervisor,
                "RondaNombre": q.SAMM_Ronda.Desripcion,
                'Identificacion': q.Persona.Identificacion,
                'NombresAgente' : q.Persona.Nombres,
                'ApellidosAgente' : q.Persona.Apellidos,
                'FechaInicio':q.SAMM_Ronda.FechaInicio,
                'FechaFin':q.SAMM_Ronda.FechaFin,
                "Estado":q.SAMM_Ronda_Punto.Estado,
                'Puntos': {
                    "IdPunto":q.SAMM_Ronda_Punto.Id,
                    "IdPuntoConcreto": q.SAMM_Bitacora_RecorridoDetalle.Id,
                    "Codigo":q.SAMM_Ronda_Punto.CodigoPunto,
                    "Coordenadas":q.SAMM_Ronda_Punto.Coordenada,
                    "Descripcion":q.SAMM_Ronda_Punto.Descripcion,
                    "EstadoPuntoConcreto":q.SAMM_Bitacora_RecorridoDetalle.Estado
                }
            }
            for q in query
            
        ]
        
        
        return jsonify({"total":len(schema),"data":schema}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
    
    
@bp.route('/getBitacoraRecorrido', methods=['POST'])
@cross_origin()
@jwt_required()
def getBitacoraRecorrido():
    try:
        idAgente = request.json["idAgente"]
        agente_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.IdAgente == idAgente).first()

        if (agente_existe is None):
            return jsonify({"message":"Usuario Agente no existe en bitacora"}),400
       
        query = (
            db.session.query(SAMM_BitacoraRecorrido,SAMM_Usuario,SAMM_Ronda,Persona)
            .join(SAMM_Ronda, SAMM_Ronda.Id == SAMM_BitacoraRecorrido.IdRonda)
            .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraRecorrido.IdAgente)
            .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)

            .filter(
                SAMM_BitacoraRecorrido.IdAgente==idAgente,
                #SAMM_Ronda.FechaInicio==datetime.now()
                )
            .order_by(SAMM_BitacoraRecorrido.FechaRecorrido.desc())  # Ordenar por fecha descendente

            .all()
            )

        schema = [
        {
            "IdUsuario": q.SAMM_Usuario.Id,
            "idRonda": q.SAMM_BitacoraRecorrido.IdRonda,
            "idRondaBitacora": q.SAMM_BitacoraRecorrido.Id,
            "fechaRecorrido": q.SAMM_BitacoraRecorrido.FechaRecorrido,
            "Nombres": f"{q.Persona.Nombres} {q.Persona.Apellidos}" if q.Persona else None,

            
            
        }
        for q in query
        ]
        return jsonify({"total":len(schema),"data":schema}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
    
@bp.route('/getRecorridoDiario/<int:idAgente>', methods=['GET'])
@cross_origin()
@jwt_required()
def getBitacoraRecorridoXId(idAgente):
    try:
        
        user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
        print(user)
        if(user.Id is None): return jsonify({"message":"Usuario  no existe"}),400
        agente_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.IdAgente == idAgente).first()
        if (agente_existe is None):
            return jsonify({"message":"Usuario Agente no existe en bitacora"}),400
        #bitacora_recorrido_squema=SAMM_BitacoraRecorridoSchema()
        print(agente_existe)
        query = (
            db.session.query(SAMM_BitacoraRecorrido,SAMM_Usuario,SAMM_Ronda,Persona,SAMM_Ubicacion)
            .join(SAMM_Ronda, SAMM_Ronda.Id == SAMM_BitacoraRecorrido.IdRonda)
            .join(SAMM_Usuario, SAMM_Usuario.Id == SAMM_BitacoraRecorrido.IdAgente)
            .join(Persona, SAMM_Usuario.IdPersona == Persona.Id)
            .join(SAMM_Ubicacion, SAMM_Ronda.IdUbicacion == SAMM_Ubicacion.Id, isouter=True)

            .filter(
                SAMM_BitacoraRecorrido.IdAgente==idAgente,
                SAMM_BitacoraRecorrido.FechaRecorrido==datetime.now().date()
                )
            .first()
            )
        schema = {
            "IdUsuario": query.SAMM_Usuario.Id,
            "idRonda": query.SAMM_BitacoraRecorrido.IdRonda,
            "idRondaBitacora": query.SAMM_BitacoraRecorrido.Id,
            "fechaRecorrido": query.SAMM_BitacoraRecorrido.FechaRecorrido,
            "Nombres": f"{query.Persona.Nombres} {query.Persona.Apellidos}" if query.Persona else None,
            "NameUbicacion": query.SAMM_Ubicacion.Descripcion if query.SAMM_Ubicacion else None,
            "descripcion": query.SAMM_Ronda.Desripcion,

        }
        
        
        return jsonify({"data":schema}), 200
        
    except Exception as e:
        print(e)
        return jsonify({'message': str(e)}), 500
        

    
@bp.route('/insertPuntosBitacora', methods=['POST'])
@cross_origin()
@jwt_required()
def insertPuntosBitacoraDetalle():
    try:
        user= SAMM_Usuario.query.filter_by(Codigo=get_jwt_identity()).first()
        if(user.Id is None): return jsonify({"message":"Usuario  no existe"}),400
    
        idAgente=request.json["idAgente"]
        idRonda=request.json["idRonda"]
        puntos= request.json["puntos"]
        print(idAgente)
        print(idRonda)
        print(puntos)
        print("-----------------------")
        #diaSemana=request.json["diaSemana"] or None
        
        # Obtener fechas de inicio y fin desde el frontend
        ronda=SAMM_Ronda.query.filter(SAMM_Ronda.Id==idRonda).first()
        
        
        fechaInicio = ronda.FechaInicio
        fechaFin = ronda.FechaFin
        frecuencia = ronda.Frecuencia


        # Convertir las fechas a objetos de datetime
        #fechaInicio = datetime.strptime(fechaInicio, "%Y-%m-%d")
        #fechaFin = datetime.strptime(fechaFin, "%Y-%m-%d")

        # Lógica para determinar las fechas según la frecuencia
        fechas = []
        delta = timedelta(days=1)
        # Mapear nombres de días a índices (0=Lunes, 1=Martes, ..., 6=Domingo)
        dias_semana = {
            "LUNES": 0,
            "MARTES": 1,
            "MIERCOLES": 2,
            "JUEVES": 3,
            "VIERNES": 4,
            "SABADO": 5,
            "DOMINGO": 6
        }
        if frecuencia == "DIARIO":
            fechas.append(fechaInicio)
            while fechaInicio < fechaFin:
                fechaInicio += delta
                fechas.append(fechaInicio)
        elif frecuencia == "SEMANAL":
            # Lógica para frecuencia semanal (agregar según día de la semana)
            diaSemana=ronda.diaSemana
        
            # Asumiendo que diaSemana es un nombre de día
            if diaSemana.upper() in dias_semana:
                indice_dia = dias_semana[diaSemana.upper()]
                while fechaInicio < fechaFin:
                    if fechaInicio.weekday() == indice_dia:
                        fechas.append(fechaInicio)
                    fechaInicio += delta
            else:
                return jsonify({'message': 'Nombre de día no válido'}), 400
        elif frecuencia == "MENSUAL":
            # Lógica para frecuencia mensual (agregar según día del mes)
            # Asumiendo que diaMes es un número de día válido
            diaMes=ronda.NumDiaMes
            #if diaSemana.upper() in dias_semana:

            while fechaInicio <= fechaFin:
                # Verificar que sea el día del mes correcto
                if fechaInicio.day == diaMes:
                    fechas.append(fechaInicio)
                    break
                fechaInicio += delta
            #else:
            #    return jsonify({'message': 'Nombre de día no válido'}), 400
        else:
            return jsonify({'message': 'Frecuencia no válida'}), 400

         # Insertar registros en SAMM_BitacoraRecorrido y SAMM_Bitacora_RecorridoDetalle
        print(fechas)
        for fecha in fechas:
            print(fecha)
            # Insertar en SAMM_BitacoraRecorrido
            bitacora_recorrido = SAMM_BitacoraRecorrido(
                IdAgente=idAgente,
                IdRonda=idRonda,
                UsuCrea=user.Id,
                UsuMod=user.Id,
                FechaCrea=datetime.now(),
                FechaMod=datetime.now(),
                Estado=1,
                FechaRecorrido=fecha
            )
            db.session.add(bitacora_recorrido)
            db.session.commit()


            for punto in puntos:
                    
                # Insertar en SAMM_Bitacora_RecorridoDetalle (ejemplo)
                bitacora_detalle = SAMM_Bitacora_RecorridoDetalle(
                    IdUsuario=idAgente,
                    IdRonda=idRonda,
                    Estado="POR INICIAR",
                    IdPuntoRonda=punto["Id"],  # Reemplazar con el valor correcto
                    Codigo="ABC",   # Reemplazar con el valor correcto
                    Descripcion=punto["Descripcion"],
                    FotoURL=None,
                    FechaCreacion=datetime.now(),
                    UsuCreacion=user.Id,
                    FechaModifica=datetime.now(),
                    UsuModifica=user.Id,
                    IdBitacoraRecorrido=bitacora_recorrido.Id  # Usar el Id generado
                )
                db.session.add(bitacora_detalle)


        # Confirmar cambios en la base de datos
        db.session.commit()

        return jsonify({'message': 'Registros insertados correctamente',}), 201

    except Exception as e:
        print(e)
        return jsonify({'message': str(e)}), 500
