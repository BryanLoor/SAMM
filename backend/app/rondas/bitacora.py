from datetime import datetime
from app.rondas import bp
from flask_cors import cross_origin
from app.models.SAMM_Persona import Persona
from flask import jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.extensions import db

from app.models.SAMM_BitacoraRecorrido import SAMM_BitacoraRecorrido
from app.models.SAMM_Bitacora_RecorridoDetalle import SAMM_Bitacora_RecorridoDetalle
from app.models.SAMM_Usuario import SAMM_Usuario
from app.models.SAMM_Ronda import SAMM_Ronda
from app.models.SAMM_Ronda_Punto import SAMM_Ronda_Punto,SAMM_Ronda_PuntoSchema



@bp.route('/getPuntosRecorridoxRonda', methods=['POST'])
@cross_origin()
@jwt_required()
def getPuntosRecorridoxRonda():
    try:
        '''idRonda = request.json["idRonda"]
        idAgente = request.json["idAgente"]
        agente_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.IdAgente == idAgente).first()
        ronda_existe = SAMM_BitacoraRecorrido.query.filter(SAMM_BitacoraRecorrido.IdRonda == idRonda).first()

        if (agente_existe is None):
            return jsonify({"message":"Usuario Agente no existe en bitacora"}),400
        if (ronda_existe is None):
            return jsonify({"message":"Ronda no existe en bitacora"}),400
        '''
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
                "Estado":q.SAMM_Bitacora_RecorridoDetalle.Estado,
                'Puntos': {
                    "IdPunto":q.SAMM_Ronda_Punto.Id,
                    "Codigo":q.SAMM_Ronda_Punto.CodigoPunto,
                    "Coordenadas":q.SAMM_Ronda_Punto.Coordenada,
                    "Descripcion":q.SAMM_Ronda_Punto.Descripcion,
                    "EstadoPunto":q.SAMM_Ronda_Punto.Estado
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
    