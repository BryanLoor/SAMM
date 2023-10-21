from datetime import datetime
from sqlalchemy import and_
from flask_jwt_extended import jwt_required, get_jwt_identity
from flask import jsonify, request
from flask_cors import cross_origin
from app.rondas import bp
from app.extensions import db
from app.models.SAMM_Bitacora_RecorridoDetalle import SAMM_Bitacora_RecorridoDetalle, SAMM_Bitacora_RecorridoDetalleSchema

@bp.route('/updatePuntoBitacoraRecorridoDetalle', methods=['POST'])
@cross_origin()
@jwt_required()
def updatePuntoBitacoraRecorridoDetalle():
    try:
        id = request.json.get('Id')
        registro = SAMM_Bitacora_RecorridoDetalle.query.get(id)

        if not registro:
            return jsonify({'message': 'Registro no encontrado'}), 404

        nuevo_estado = request.json.get('Estado')
        registro.Estado = nuevo_estado

        db.session.commit()

        return SAMM_Bitacora_RecorridoDetalleSchema().jsonify(registro)
    except Exception as e:
        return jsonify({'message': 'Error al actualizar el registro', 'error': str(e)}), 500
